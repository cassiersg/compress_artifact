library ieee;
use ieee.std_logic_1164.all;

use work.skinnypkg.all;

entity mixcolumns is
	port (x : in  std_logic_vector(127 downto 0);
          y : out std_logic_vector(127 downto 0));
end mixcolumns;

architecture parallel of mixcolumns is

	constant w : integer := 8;

	signal c1_x2x0, c2_x2x0, c3_x2x0, c4_x2x0 : std_logic_vector((w - 1) downto 0);
	signal c1_x2x1, c2_x2x1, c3_x2x1, c4_x2x1 : std_logic_vector((w - 1) downto 0);

begin

	-- x2 xor x1
	c1_x2x1 <= x((12 * w - 1) downto (11 * w)) xor x(( 8 * w - 1) downto ( 7 * w));
	c2_x2x1 <= x((11 * w - 1) downto (10 * w)) xor x(( 7 * w - 1) downto ( 6 * w));
	c3_x2x1 <= x((10 * w - 1) downto ( 9 * w)) xor x(( 6 * w - 1) downto ( 5 * w));
	c4_x2x1 <= x(( 9 * w - 1) downto ( 8 * w)) xor x(( 5 * w - 1) downto ( 4 * w));

	-- x2 xor x0
	c1_x2x0 <= x((16 * w - 1) downto (15 * w)) xor x(( 8 * w - 1) downto ( 7 * w));
	c2_x2x0 <= x((15 * w - 1) downto (14 * w)) xor x(( 7 * w - 1) downto ( 6 * w));
	c3_x2x0 <= x((14 * w - 1) downto (13 * w)) xor x(( 6 * w - 1) downto ( 5 * w));
	c4_x2x0 <= x((13 * w - 1) downto (12 * w)) xor x(( 5 * w - 1) downto ( 4 * w));

	-- column 1
	y((16 * w - 1) downto (15 * w)) <= c1_x2x0 xor x(( 4 * w - 1) downto ( 3 * w));
	y((12 * w - 1) downto (11 * w)) <= x((16 * w - 1) downto (15 * w));
	y(( 8 * w - 1) downto ( 7 * w)) <= c1_x2x1;
	y(( 4 * w - 1) downto ( 3 * w)) <= c1_x2x0;

	-- column 2
	y((15 * w - 1) downto (14 * w)) <= c2_x2x0 xor x(( 3 * w - 1) downto ( 2 * w));
	y((11 * w - 1) downto (10 * w)) <= x((15 * w - 1) downto (14 * w));
	y(( 7 * w - 1) downto ( 6 * w)) <= c2_x2x1;
	y(( 3 * w - 1) downto ( 2 * w)) <= c2_x2x0;

	-- column 3
	y((14 * w - 1) downto (13 * w)) <= c3_x2x0 xor x(( 2 * w - 1) downto ( 1 * w));
	y((10 * w - 1) downto ( 9 * w)) <= x((14 * w - 1) downto (13 * w));
	y(( 6 * w - 1) downto ( 5 * w)) <= c3_x2x1;
	y(( 2 * w - 1) downto ( 1 * w)) <= c3_x2x0;

	-- column 4
	y((13 * w - 1) downto (12 * w)) <= c4_x2x0 xor x(( 1 * w - 1) downto ( 0 * w));
	y(( 9 * w - 1) downto ( 8 * w)) <= x((13 * w - 1) downto (12 * w));
	y(( 5 * w - 1) downto ( 4 * w)) <= c4_x2x1;
	y(( 1 * w - 1) downto ( 0 * w)) <= c4_x2x0;

end parallel;
