(* fv_prop = "PINI", fv_strat = "flatten" *)
module MSKaes_128bits_fsm
(
    clk,
    nrst,
    valid_in,
    ready,
    cipher_valid,
    // State
    feed_in,
    // State reg control
    state_reg_enable,
    state_mux_lastR,
    // Key reg control
    key_reg_enable,
    // Sbox 
    SB_valid_in,
    // Key scheduling
    KS_in_valid,
    KS_rcon_update,
    KS_rcon_rst
);

// IOs
input clk;
input nrst;
input valid_in;
output reg ready;
output cipher_valid;

output reg feed_in;
output reg state_reg_enable;
output reg state_mux_lastR;

output reg key_reg_enable;

output reg SB_valid_in;

output reg KS_in_valid;
output reg KS_rcon_update;
output reg KS_rcon_rst;

// Localparam
localparam SBOX_HPC_LAT = 4;


// Counter to keep track of the amount of rounds
reg [3:0] cnt_rounds;
reg rst_cnt_rounds;
reg inc_cnt_rounds;

always@(posedge clk)
if(rst_cnt_rounds) begin
    cnt_rounds <= 0;
end else if(inc_cnt_rounds) begin
    cnt_rounds <= cnt_rounds + 1;
end

wire in_final_full_round = cnt_rounds == 8;

// Counter to keep track of the amount of cycle inside a round
reg [3:0] cnt_fsm;
reg rst_cnt_fsm;
reg inc_cnt_fsm;

always@(posedge clk)
if(rst_cnt_fsm) begin
    cnt_fsm <= 0;
end else if(inc_cnt_fsm) begin
    cnt_fsm <= cnt_fsm + 1;
end

wire last_round_cycle = cnt_fsm == SBOX_HPC_LAT; 

// FSM states
localparam IDLE = 0,
WAIT_R = 1,
WAIT_LAST_R = 2;

reg [2:0] state, nextstate;

// State register
always@(posedge clk)
if(!nrst) begin
    state <= IDLE;
end else begin
    state <= nextstate;
end

// register to create the valid out pulse
reg pulse_valid_out;
reg valid_out_reg;
always@(posedge clk)
if(!nrst) begin
    valid_out_reg <= 0;
end else begin
    valid_out_reg <= !valid_out_reg && pulse_valid_out; 
end

assign cipher_valid = valid_out_reg;

// Global status
reg in_fetch;
reg in_round;
reg in_last_round;
reg in_reset_holder;

always@(*) begin
    nextstate = state;

    ready = 0;
    
    pulse_valid_out = 0;

    rst_cnt_rounds = 0;
    rst_cnt_fsm = 0;

    in_fetch = 0;
    in_round = 0;
    in_last_round = 0;
    in_reset_holder = 0;

    case(state)
        IDLE: begin
            ready = 1;
            if(valid_in) begin
                in_fetch = 1;
                rst_cnt_fsm = 1;
                rst_cnt_rounds = 1;
                nextstate = WAIT_R;
            end else begin
                in_reset_holder = 1;
            end
        end
        WAIT_R: begin
            in_round = 1;
            if(last_round_cycle) begin
                if(in_final_full_round) begin
                    nextstate = WAIT_LAST_R;
                end else begin
                    nextstate = WAIT_R;
                end
                rst_cnt_fsm = 1;
            end
        end
        WAIT_LAST_R: begin
            in_last_round = 1;
            if(last_round_cycle) begin
                nextstate = IDLE;
                rst_cnt_fsm = 1;
                pulse_valid_out = 1;
            end
        end
    endcase
end


// Logic for the datapath control
always@(*) begin
    feed_in = 0;
    
    state_mux_lastR = 0;

    state_reg_enable = 0;
    key_reg_enable = 0;

    // TODO crappy ...
    SB_valid_in = 0;


    KS_in_valid = 0;
    KS_rcon_update = 0;
    KS_rcon_rst = 0;

    inc_cnt_rounds = 0;
    inc_cnt_fsm = 0;

    // Fetching mechanism
    if(in_reset_holder) begin
        state_reg_enable = 1;
        key_reg_enable = 1;
        feed_in = 1;
    end
    if(in_fetch) begin
        state_reg_enable = 1;
        key_reg_enable = 1;
        feed_in = 1;
        KS_rcon_rst = 1;
    end
    // In rounds routing   
    if(in_round || in_last_round) begin
        inc_cnt_fsm = 1;
        if(cnt_fsm==0) begin
            KS_in_valid = 1;
            SB_valid_in = 1;
        end
        if(last_round_cycle) begin
            inc_cnt_rounds = 1;
            KS_rcon_update = 1;
            state_reg_enable = 1;
            key_reg_enable = 1;
        end
    end
    // In last round mux 
    if(in_last_round && last_round_cycle) begin
        state_mux_lastR = 1;
        state_reg_enable = 1;
        key_reg_enable = 1;
    end 

end


endmodule

