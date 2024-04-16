library ieee;
use ieee.std_logic_1164.all;

entity statereg is
	generic (n : integer);
	port (clk : in 	std_logic;
          se  : in 	std_logic;
          d   : in 	std_logic_vector((n - 1) downto 0);
          ds  : in 	std_logic_vector((n - 1) downto 0);
          q   : out std_logic_vector((n - 1) downto 0));
end statereg;

architecture structural of statereg is
begin

	gen : for i in 0 to (n - 1) generate
        x : entity work.sff port map (clk, se, d(i), ds(i), q(i));
	end generate;

end structural;
