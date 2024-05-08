library ieee;
use ieee.std_logic_1164.all;

use work.skinnypkg.all;

entity sbox is
	port (x : in  std_logic_vector(7 downto 0);
          y : out std_logic_vector(7 downto 0));
end sbox;

architecture word of sbox is

	signal no3, xo3, no2, xo2, no1, xo1, no0, xo0 : std_logic;
	signal o, p									  : std_logic_vector(39 downto 0);

begin

	-- 8-bit s-box
	p(7 downto 0) <= x;

	gen : for i in 0 to 3 generate
		o((8 * i +  7) downto (8 * i + 4)) <= p((8 * i + 7) downto (8 * i + 5)) & (p(8 * i + 4) xor (p(8 * i + 7) nor p(8 * i + 6)));
		o((8 * i +  3) downto (8 * i + 0)) <= p((8 * i + 3) downto (8 * i + 1)) & (p(8 * i + 0) xor (p(8 * i + 3) nor p(8 * i + 2)));
		p((8 * i + 15) downto (8 * i + 8)) <= o((8 * i + 2)) & o((8 * i + 1)) & o((8 * i + 7)) & o((8 * i + 6)) & o((8 * i + 4)) & o((8 * i + 0)) & o((8 * i + 3)) & o((8 * i + 5));
	end generate;

	y <= o(31 downto 27) & o(25) & o(26) & o(24);

end word;
