import argparse 
import json
import functools as ft
import networkx as nx
import re

def parser_add_option(parser):
    parser.add_argument(
            "--netlist-file",
            type=str,
            default="yosys_canright_aes_sbox_trivial_from_c.json",
            help="Yosys JSON netlist file"
            )
    parser.add_argument(
            "--top",
            type=str,
            default="Sbox",
            help=""
            )
    parser.add_argument(
            "--compress-file",
            type=str,
            default="canright-compress.txt",
            help="COMPRESS input file"
            )

class Counter:
    def __init__(self):
        self.value = 0

    def incr(self):
        self.value += 1

    def __str__(self):
        return "{}".format(self.value)

class InOrderArchitectureBuilder:
    OPregex="[+!&]"
    def __init__(self):
        self.graph = nx.DiGraph()
        self.dependencies_map = {}
        self.variable_id_map = {} 
        self.statement_map = {}
        # Resulting from a success solve
        self.sorted_node_id = None  
        self.inputs = None

    def node_identifier(self,node_vars):
        return ft.reduce(lambda a,b: str(a)+'_'+str(b), node_vars).replace(' ','')

    # Create a node variable (may cover multiple variables) 
    # with the appropriate dependency link.
    def add_dependency_node(self,node_vars, dependency_vars, node_statement: str):
        # Generate the node identifier
        node_id = self.node_identifier(node_vars)
        # Assign the id to each variable in the map 
        for var_id in node_vars:
            if var_id not in self.variable_id_map:
                self.variable_id_map[var_id] = node_id
            else:
                raise ValueError("Trying to re-define an already defined variable.")
        # Create the dependency list  
        self.dependencies_map[node_id] = dependency_vars
        # Add the rule for building node var
        self.statement_map[node_id] = node_statement
        # Clear solution
        self.sorted_statement = None
        self.inputs = None

    # Add an architectural statement. Single operator/function statement handled.  
    def add_statement(self, statement: str):
        # Clean statement        
        clean_statement = statement.replace(" ","")
        clean_statement = statement.replace("\n","")
        split_eq = clean_statement.split("=")
        assert len(split_eq) == 2
        out_var_id = re.split(',',split_eq[0].replace('(','').replace(')','').replace(' ',''))
        # Parse input
        if ',' in split_eq[1]:
            # Function as operator
            in_var_id = re.split(',',split_eq[1].split('(')[1].split(')')[0])
        else:
            in_var_id = re.split(InOrderArchitectureBuilder.OPregex,split_eq[1].replace(" ",""))
        # Create the node
        self.add_dependency_node(out_var_id, in_var_id, statement)


    # Solve dependencies order
    def solve(self):
        # First, create the directed acyclic graph with variable dependcies
        G = nx.DiGraph()
        # Add all the intermediate variable as variables
        G.add_nodes_from(self.dependencies_map.keys())
        input_set_identified = []
        no_inputs = [e for e in self.variable_id_map.keys()]
        for vname, dvars in self.dependencies_map.items():
            for dep_varid in dvars:
                # If not into the variable map, then it is a global input
                if not(dep_varid in no_inputs) and not(dep_varid in input_set_identified):
                    input_set_identified.append(dep_varid)
                    self.variable_id_map[dep_varid] = dep_varid
                    G.add_node(dep_varid)
                # Create the edge
                G.add_edge(self.variable_id_map[dep_varid], vname)

        # Solve the topological sort
        self.sorted_node_id = nx.topological_sort(G)
        self.input = input_set_identified

    # Return a list containeing the sorted statement
    # CAUTION: inputs not included
    def get_sorted_statements(self):
        ordered_statement = []
        for s in self.sorted_node_id:
            if s not in self.input:
                ordered_statement.append(self.statement_map[s])
        return ordered_statement

def parse_ports(topmod, varmap, txt_out):
    # Add input/output declaration
    top_ports=topmod['ports']
    input_ports = []
    output_ports = []
    input_bits = []
    output_bits = []
    for pname in top_ports:
        # Get the port
        port = top_ports[pname]
        port_direction = port["direction"]
        # Keep track of port sigs to create the IO declarations
        list_port_sigs = []
        list_port_bits = []
        # Add to map the corresponding bits
        for bi,be in enumerate(port['bits']):
            variables_map[be] = "{}{}".format(pname,bi)
            list_port_sigs += [variables_map[be]]
            list_port_bits += [be]
        # Append to corresponding port
        if port_direction == "input":
            input_ports += list_port_sigs
            input_bits += list_port_bits
        elif port_direction == "output":
            output_ports += list_port_sigs
            output_bits += list_port_bits
        else:
            raise ValueError("Port direction not handled")
    # Create the INPUT/OUTPUT declaration
    input_str_port_sigs = ft.reduce(lambda a, b: a+' '+b, input_ports)
    output_str_port_sigs = ft.reduce(lambda a, b: a+' '+b, output_ports)
    txt_out.append("INPUTS {}".format(input_str_port_sigs))
    txt_out.append("OUTPUTS {}".format(output_str_port_sigs))
    return input_bits, output_bits
            
def filter_name(name):
    to_remove = ['$','.',':']
    nv = name
    for c in to_remove:
        nv = nv.replace(c,'')
    return nv

def generated_var_name(index):
    return "gen{}".format(index)

def fetch_variable_name(varmap, bit_index, autogen_index):
    if not(bit_index in varmap):
        name_var = generated_var_name(autogen_index)
        varmap[bit_index] = name_var
        autogen_index.incr()
    else:
        name_var = varmap[bit_index]
    # Return variable
    return name_var

def process_inst_NOT(cell_inst, varmap, lines_out, index):
    out_index = cell_inst['connections']['Y'][0]
    in_index = cell_inst['connections']['A'][0]
    # Get/Generate the output signal name
    name_out = fetch_variable_name(varmap, out_index, index)
    # Get/Generate the input signal name
    name_in = fetch_variable_name(varmap, in_index, index)
    # Create the line
    line = "{} = !{}".format(name_out, name_in)
    lines_out.append(line) 

def process_inst_XOR(cell_inst, varmap, lines_out, index):
    ina_index = cell_inst['connections']['A'][0]
    inb_index = cell_inst['connections']['B'][0]
    outy_index = cell_inst['connections']['Y'][0]
    # Fetch variable name
    varn_ina = fetch_variable_name(varmap, ina_index, index)
    varn_inb = fetch_variable_name(varmap, inb_index, index)
    varn_outy = fetch_variable_name(varmap, outy_index, index)
    # Create the line
    line = "{} = {} + {}".format(varn_outy, varn_ina, varn_inb)
    lines_out.append(line)

def process_inst_G4mul(cell_inst, varmap, lines_out, index):
    inx_indexes = [cell_inst['connections']['x'][i] for i in range(2)]
    iny_indexes = [cell_inst['connections']['y'][i] for i in range(2)]
    outz_indexes = [cell_inst['connections']['z'][i] for i in range(2)]
    # Fetch varname 
    varn_x = [fetch_variable_name(varmap, inx_indexes[i], index) for i in range(2)]
    varn_y = [fetch_variable_name(varmap, iny_indexes[i], index) for i in range(2)]
    varn_z = [fetch_variable_name(varmap, outz_indexes[i], index) for i in range(2)]
    # Create the line
    line = "({}, {}) = G4_mul({}, {}, {}, {})".format(
            *varn_z,
            *varn_x,
            *varn_y,
            )
    lines_out.append(line)

def process_inst_G16mul(cell_inst, varmap, lines_out, index):
    inx_indexes = [cell_inst['connections']['x'][i] for i in range(4)]
    iny_indexes = [cell_inst['connections']['y'][i] for i in range(4)]
    outz_indexes = [cell_inst['connections']['z'][i] for i in range(4)]
    # Fetch varname 
    varn_x = [fetch_variable_name(varmap, inx_indexes[i], index) for i in range(4)]
    varn_y = [fetch_variable_name(varmap, iny_indexes[i], index) for i in range(4)]
    varn_z = [fetch_variable_name(varmap, outz_indexes[i], index) for i in range(4)]
    # Create the line
    line = "({}, {}, {}, {}) = G16_mul({}, {}, {}, {}, {}, {}, {}, {})".format(
            *varn_z,
            *varn_x,
            *varn_y,
            )
    lines_out.append(line)

def process_inst_AND(cell_inst, varmap, lines_out, index):
    ina_index = cell_inst['connections']['A'][0]
    inb_index = cell_inst['connections']['B'][0]
    outy_index = cell_inst['connections']['Y'][0]
    # Fetch variable name
    varn_ina = fetch_variable_name(varmap, ina_index, index)
    varn_inb = fetch_variable_name(varmap, inb_index, index)
    varn_outy = fetch_variable_name(varmap, outy_index, index)
    # Create the line
    line = "{} = {} & {}".format(varn_outy, varn_ina, varn_inb)
    lines_out.append(line)

def process_instance(cell_name, cell_inst, varmap, lines_out, index):
    inst_type = cell_inst['type']
    if inst_type == '$_NOT_':
        process_inst_NOT(cell_inst, varmap, lines_out, index)
    elif inst_type == "$_XOR_":
        process_inst_XOR(cell_inst, varmap, lines_out, index)
    elif inst_type == "G4_mul":
        process_inst_G4mul(cell_inst, varmap, lines_out, index)
    elif inst_type == "G16_mul":
        process_inst_G16mul(cell_inst, varmap, lines_out, index)
    elif inst_type == "$_AND_":
        process_inst_AND(cell_inst, varmap, lines_out, index)
    else:
        raise ValueError("Cell type '{}' not handled".format(inst_type))

def parse_cells(topmod, varmap, lines_out):
    index_cnt = Counter()
    for instance in topmod['cells']:
        cell_inst = topmod['cells'][instance]
        process_instance(instance, cell_inst, varmap, lines_out, index_cnt)

if __name__ == "__main__":
    # Parse args
    parser = argparse.ArgumentParser(description="Yosys to COMPRESS input formatter")
    parser_add_option(parser)
    args = parser.parse_args()

    # Load json
    with open(args.netlist_file,'r') as f:
        yosys_netlist = json.load(f)

    # Running var map and circuit text
    variables_map = {}
    circuit_compress_lines = []

    # Process inputs/output ports
    input_bits, output_bits = parse_ports(
            yosys_netlist['modules'][args.top],
            variables_map,
            circuit_compress_lines
            )

    # Process each module of the top module, sequentially  
    parse_cells(
            yosys_netlist['modules'][args.top],
            variables_map,
            circuit_compress_lines
            )

    # Create the architecture builder in order from generated lines 
    # appart from INPUT/OUTPUTS
    builder = InOrderArchitectureBuilder()
    for s in circuit_compress_lines[2:]:
        builder.add_statement(s)

    # Solve order and recover statement in order
    builder.solve()
    circuit_compress_lines[2:] = builder.get_sorted_statements()

    # Dump all lines in a file    
    with open(args.compress_file, 'w') as f:
        f.write("\n".join(circuit_compress_lines)) 


    
