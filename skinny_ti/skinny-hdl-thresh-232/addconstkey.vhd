library ieee;
use ieee.std_logic_1164.all;

use work.skinnypkg.all;

entity addconstkey is
	generic (ts : tweak_size := tweak_size_1n);
	port (const	    : in  std_logic_vector(5 downto 0);
		  round_key	: in  std_logic_vector((get_tweak_size(ts) - 1) downto 0);
		  data_in	: in  std_logic_vector(127 downto 0);
		  data_out  : out std_logic_vector(127 downto 0));
end addconstkey;

architecture parallel of addconstkey is

	constant n : integer := 128;
	constant t : integer := get_tweak_size(ts);
	constant w : integer := 8;

	signal const_addition : std_logic_vector((n - 1) downto 0);

begin

	-- constant addition
	const_addition(127 downto 124) <= data_in(127 downto 124);
	const_addition(123 downto 120) <= data_in(123 downto 120) xor const(3 downto 0);
	const_addition(119 downto  90) <= data_in(119 downto  90);
	const_addition( 89 downto  88) <= data_in( 89 downto  88) xor const(5 downto 4);
	const_addition( 87 downto  58) <= data_in( 87 downto  58);
	const_addition(57) 	    	   <= not(data_in(57));
	const_addition( 56 downto   0) <= data_in( 56 downto   0);

	-- roundkey addition
	t1n : if ts = tweak_size_1n generate
		data_out((16 * w - 1) downto (12 * w)) <= const_addition((16 * w - 1) downto (12 * w)) xor round_key((16 * w - 1) downto (12 * w));
		data_out((12 * w - 1) downto ( 8 * w)) <= const_addition((12 * w - 1) downto ( 8 * w)) xor round_key((12 * w - 1) downto ( 8 * w));
	end generate;

	t2n : if ts = tweak_size_2n generate
		data_out((16 * w - 1) downto (12 * w)) <= const_addition((16 * w - 1) downto (12 * w)) xor round_key((1 * n + 16 * w - 1) downto (1 * n + 12 * w)) xor round_key((16 * w - 1) downto (12 * w));
		data_out((12 * w - 1) downto ( 8 * w)) <= const_addition((12 * w - 1) downto ( 8 * w)) xor round_key((1 * n + 12 * w - 1) downto (1 * n +  8 * w)) xor round_key((12 * w - 1) downto ( 8 * w));
	end generate;

	t3n : if ts = tweak_size_3n generate
		data_out((16 * w - 1) downto (12 * w)) <= const_addition((16 * w - 1) downto (12 * w)) xor round_key((2 * n + 16 * w - 1) downto (2 * n + 12 * w)) xor round_key((1 * n + 16 * w - 1) downto (1 * n + 12 * w)) xor round_key((16 * w - 1) downto (12 * w));
		data_out((12 * w - 1) downto ( 8 * w)) <= const_addition((12 * w - 1) downto ( 8 * w)) xor round_key((2 * n + 12 * w - 1) downto (2 * n +  8 * w)) xor round_key((1 * n + 12 * w - 1) downto (1 * n +  8 * w)) xor round_key((12 * w - 1) downto ( 8 * w));
	end generate;

	data_out(( 8 * w - 1) downto ( 4 * w)) <= const_addition(( 8 * w - 1) downto ( 4 * w));
	data_out(( 4 * w - 1) downto ( 0 * w)) <= const_addition(( 4 * w - 1) downto ( 0 * w));

end parallel;
