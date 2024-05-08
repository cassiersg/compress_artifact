library ieee;
use ieee.std_logic_1164.all;

use work.skinnypkg.all;

entity permutation is
	port (x : in  std_logic_vector(127 downto 0);
          y : out std_logic_vector(127 downto 0));
end permutation;

architecture parallel of permutation is

	constant w : integer := 8;

begin

	-- row 1
	y((16 * w - 1) downto (15 * w)) <= x(( 7 * w - 1) downto ( 6 * w));
	y((15 * w - 1) downto (14 * w)) <= x(( 1 * w - 1) downto ( 0 * w));
	y((14 * w - 1) downto (13 * w)) <= x(( 8 * w - 1) downto ( 7 * w));
	y((13 * w - 1) downto (12 * w)) <= x(( 3 * w - 1) downto ( 2 * w));

	-- row 2
	y((12 * w - 1) downto (11 * w)) <= x(( 6 * w - 1) downto ( 5 * w));
	y((11 * w - 1) downto (10 * w)) <= x(( 2 * w - 1) downto ( 1 * w));
	y((10 * w - 1) downto ( 9 * w)) <= x(( 4 * w - 1) downto ( 3 * w));
	y(( 9 * w - 1) downto ( 8 * w)) <= x(( 5 * w - 1) downto ( 4 * w));

	-- row 3
	y(( 8 * w - 1) downto ( 7 * w)) <= x((16 * w - 1) downto (15 * w));
	y(( 7 * w - 1) downto ( 6 * w)) <= x((15 * w - 1) downto (14 * w));
	y(( 6 * w - 1) downto ( 5 * w)) <= x((14 * w - 1) downto (13 * w));
	y(( 5 * w - 1) downto ( 4 * w)) <= x((13 * w - 1) downto (12 * w));

	-- row 4
	y(( 4 * w - 1) downto ( 3 * w)) <= x((12 * w - 1) downto (11 * w));
	y(( 3 * w - 1) downto ( 2 * w)) <= x((11 * w - 1) downto (10 * w));
	y(( 2 * w - 1) downto ( 1 * w)) <= x((10 * w - 1) downto ( 9 * w));
	y(( 1 * w - 1) downto ( 0 * w)) <= x(( 9 * w - 1) downto ( 8 * w));

end parallel;
