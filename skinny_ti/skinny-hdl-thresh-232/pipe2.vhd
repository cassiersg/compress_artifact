library ieee;
use ieee.std_logic_1164.all;

entity pipe2 is
	port (clk : in 	std_logic;
          d   : in 	std_logic_vector(143 downto 0);
          q   : out std_logic_vector(143 downto 0));
end pipe2;

architecture structural of pipe2 is
begin

	gen : for i in 0 to 143 generate
        x : entity work.ff port map (clk, d(i), q(i));
	end generate;

end structural;

