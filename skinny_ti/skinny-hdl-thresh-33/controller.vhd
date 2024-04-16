library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.skinnypkg.all;

entity controller is
	generic (ts : tweak_size := tweak_size_1n);
	port (clk   : in std_logic;
		  
          reset_n : in std_logic; -- active-low synchronous
          start   : in std_logic; -- trigger encryption
		  
          busy : out std_logic;
          done : out std_logic;

          -- internal
          load_upd  : out std_logic;                   -- indicator to load new state after end of round
          round_cst : out std_logic_vector(5 downto 0) -- round constant
    );
end controller;

architecture round of controller is

	signal rcst, next_rcst   : std_logic_vector(5 downto 0);
    signal epoch, next_epoch : unsigned(1 downto 0);
    
    type type_state is (st_idle, st_enc);
    signal state, next_state : type_state;

begin

	controller_regs : process(clk) begin
		if rising_edge(clk) then
			if (reset_n = '0') then
                state <= st_idle;
			    rcst  <= "000001";
                epoch <= "00";
            else
				state <= next_state;
			    rcst  <= next_rcst;
                epoch <= next_epoch;
			end if;
		end if;
	end process;

    fsm : process(state, rcst, start, epoch) begin
        next_state <= st_idle;
        next_rcst  <= "000001";
        next_epoch <= "00";
        load_upd   <= '0';
        busy       <= '0';
        done       <= '0';

        case state is
            when st_idle =>
                next_state <= st_idle;
                if start = '1' then
                    next_state <= st_enc;
                end if;

            when st_enc =>
                next_state <= st_enc;
                next_epoch <= epoch + 1;
                next_rcst  <= rcst;
                busy       <= '1';
                if rcst = "110100" then
                    next_epoch <= "00";
                    next_state <= st_idle;
                    done <= '1';
                elsif epoch = 1 then
                    next_epoch <= "00";
                    next_rcst  <= rcst(4 downto 0) & (rcst(5) xnor rcst(4));
                    load_upd   <= '1';
                end if;
        end case;
    end process;

	round_cst <= rcst;

end round;
