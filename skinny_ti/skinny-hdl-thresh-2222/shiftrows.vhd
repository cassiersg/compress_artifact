library ieee;
use ieee.std_logic_1164.all;

use work.skinnypkg.all;

entity shiftrows is
	port (x : in  std_logic_vector (127 downto 0);
          y : out std_logic_vector (127 downto 0));
end shiftrows;

architecture parallel of shiftrows is

	constant w : integer := 8;

begin

	-- row 1
	y((16 * w - 1) downto (12 * w)) <= x((16 * w - 1) downto (12 * w));

	-- row 2
	y((12 * w - 1) downto ( 8 * w)) <= x(( 9 * w - 1) downto ( 8 * w)) & x((12 * w - 1) downto ( 9 * w));

	-- row 3
	y(( 8 * w - 1) downto ( 4 * w)) <= x(( 6 * w - 1) downto ( 4 * w)) & x(( 8 * w - 1) downto ( 6 * w));

	-- row 4
	y(( 4 * w - 1) downto ( 0 * w)) <= x(( 3 * w - 1) downto ( 0 * w)) & x(( 4 * w - 1) downto ( 3 * w));

end parallel;
