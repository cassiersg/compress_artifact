library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.skinnypkg.all;

entity controller is
	generic (ts : tweak_size := tweak_size_1n);
	port (clk   : in std_logic;
		  reset	: in std_logic;
		    
          done : out std_logic;

          round_cst	  : out std_logic_vector(5 downto 0);
          round_epoch : out unsigned(1 downto 0));
end controller;

architecture round of controller is

	signal state, update : std_logic_vector(5 downto 0);
    signal epoch         : unsigned(1 downto 0);

begin

	-- state
	reg : process(clk) begin
		if rising_edge(clk) then
			if (reset = '1') then
				state <= (others => '0');
            elsif (epoch = 2) then
				state <= update;
			end if;
		end if;
	end process;

    -- epoch
    epc : process(clk) begin
        if rising_edge(clk) then
            if (reset = '1') then
                epoch <= "00";
            elsif epoch < 2 then
                epoch <= epoch + 1;
            else
                epoch <= "00";
            end if;
        end if;
    end process;

	-- update function
	update <= state(4 downto 0) & (state(5) xnor state(4));

	-- constant
	round_cst <= update;

    -- epoch
    round_epoch <= epoch;

	-- done signal
	chk_128_1n : if ts = tweak_size_1n generate done <= '1' when (update = "011010") else '0'; end generate;
	chk_128_2n : if ts = tweak_size_2n generate done <= '1' when (update = "000100") else '0'; end generate;
	chk_128_3n : if ts = tweak_size_3n generate done <= '1' when (update = "001010") else '0'; end generate;

end round;
