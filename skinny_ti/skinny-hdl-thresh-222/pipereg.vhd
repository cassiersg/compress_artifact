library ieee;
use ieee.std_logic_1164.all;

entity pipereg is
    generic (n : integer);
	port (clk : in 	std_logic;
          d   : in 	std_logic_vector((n-1) downto 0);
          q   : out std_logic_vector((n-1) downto 0));
end pipereg;

architecture structural of pipereg is
begin

	gen : for i in 0 to (n-1) generate
        x : entity work.ff port map (clk, d(i), q(i));
	end generate;

end structural;

