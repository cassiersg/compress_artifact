library ieee;
use ieee.std_logic_1164.all;

entity pipe is
	port (clk : in 	std_logic;
          d   : in 	std_logic_vector(127 downto 0);
          q   : out std_logic_vector(127 downto 0));
end pipe;

architecture structural of pipe is
begin

	gen : for i in 0 to 127 generate
        x : entity work.ff port map (clk, d(i), q(i));
	end generate;

end structural;

