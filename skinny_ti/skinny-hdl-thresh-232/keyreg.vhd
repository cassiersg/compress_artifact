library ieee;
use ieee.std_logic_1164.all;

entity keyreg is
	generic (n : integer);
	port (clk : in 	std_logic;
          se  : in 	std_logic;
          en  : in  std_logic;
          d   : in 	std_logic_vector((n - 1) downto 0);
          ds  : in 	std_logic_vector((n - 1) downto 0);
          q   : out std_logic_vector((n - 1) downto 0));
end keyreg;

architecture structural of keyreg is
begin

	gen : for i in 0 to (n - 1) generate
        x : entity work.sffe port map (clk, se, en, d(i), ds(i), q(i));
	end generate;

end structural;
