library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.skinnypkg.all;

entity keyexpansion is
	generic (ts : tweak_size := tweak_size_1n);
	port (clk       : in  std_logic;
          reset		: in  std_logic;

          key		  : in  std_logic_vector ((get_tweak_size(ts) - 1) downto 0);
          round_epoch : in  unsigned(1 downto 0);

		  round_key	  : out std_logic_vector ((get_tweak_size(ts) - 1) downto 0));
end keyexpansion;

architecture round of keyexpansion is

	constant w : integer := 8;
	constant n : integer := 128;
	constant t : integer := get_tweak_size(ts);

	signal key_state, key_next, key_perm : std_logic_vector((t - 1) downto 0);

    signal regen : std_logic;

begin

    regen <= '1' when round_epoch = 3 else '0';

	-- register stage
	rs : entity work.keyreg generic map (n => t) port map (clk, reset, regen, key_next, key, key_state);

	-- tweakey array permutations : tk1
	tk1 : if ts = tweak_size_1n or ts = tweak_size_2n or ts = tweak_size_3n generate
		
        -- permutation 
		p1 : entity work.permutation port map (key_state ((t - 0 * n - 1) downto (t - 1 * n)), key_perm((t - 0 * n - 1) downto (t - 1 * n)));
		
        -- no lfsr
		key_next((t - 0 * n - 1) downto (t - 1 * n)) <= key_perm((t - 0 * n - 1) downto (t - 1 * n));

	end generate;

	-- tweakey array permutations : tk2
    tk2 : if ts = tweak_size_2n or ts = tweak_size_3n generate
		-- permutation
		p2 : entity work.permutation port map (key_state ((t - 1 * n - 1) downto (t - 2 * n)), key_perm((t - 1 * n - 1) downto (t - 2 * n)));

		-- lfsr
		lfsr2 : for i in 0 to 3 generate
			key_next((t + w * (i + 13) - 2 * n - 1) downto (t + w * (i + 12) - 2 * n)) <= key_perm((t + w * (i + 13) - 2 * n - 2) downto (t + w * (i + 12) - 2 * n)) & (key_perm(t + w * (i + 13) - 2 * n - 1) xor key_perm(t + w * (i + 13) - 2 * n - (w / 4) - 1));
			key_next((t + w * (i +  9) - 2 * n - 1) downto (t + w * (i +  8) - 2 * n)) <= key_perm((t + w * (i +  9) - 2 * n - 2) downto (t + w * (i +  8) - 2 * n)) & (key_perm(t + w * (i +  9) - 2 * n - 1) xor key_perm(t + w * (i +  9) - 2 * n - (w / 4) - 1));
			key_next((t + w * (i +  5) - 2 * n - 1) downto (t + w * (i +  4) - 2 * n)) <= key_perm((t + w * (i +  5) - 2 * n - 1) downto (t + w * (i +  4) - 2 * n));
			key_next((t + w * (i +  1) - 2 * n - 1) downto (t + w * (i +  0) - 2 * n)) <= key_perm((t + w * (i +  1) - 2 * n - 1) downto (t + w * (i +  0) - 2 * n));
		end generate;

	end generate;

	-- tweakey array permutations : tk3
	tk3 : if ts = tweak_size_3n generate

		-- permutation
		p3 : entity work.permutation port map (key_state ((t - 2 * n - 1) downto (t - 3 * n)), key_perm((t - 2 * n - 1) downto (t - 3 * n)));

		-- lfsr
		lfsr3 : for i in 0 to 3 generate
			key_next((t + w * (i + 13) - 3 * n - 1) downto (t + w * (i + 12) - 3 * n)) <= (key_perm(t + w * (i + 12) - 3 * n) xor key_perm(t + w * (i + 13) - 3 * n - (w / 4))) & key_perm((t + w * (i + 13) - 3 * n - 1) downto (t + w * (i + 12) - 3 * n + 1));
			key_next((t + w * (i +  9) - 3 * n - 1) downto (t + w * (i +  8) - 3 * n)) <= (key_perm(t + w * (i +  8) - 3 * n) xor key_perm(t + w * (i +  9) - 3 * n - (w / 4))) & key_perm((t + w * (i +  9) - 3 * n - 1) downto (t + w * (i +  8) - 3 * n + 1));
			key_next((t + w * (i +  5) - 3 * n - 1) downto (t + w * (i +  4) - 3 * n)) <= key_perm((t + w * (i +  5) - 3 * n - 1) downto (t + w * (i +  4) - 3 * n));
			key_next((t + w * (i +  1) - 3 * n - 1) downto (t + w * (i +  0) - 3 * n)) <= key_perm((t + w * (i +  1) - 3 * n - 1) downto (t + w * (i +  0) - 3 * n));
		end generate;

	end generate;

	-- key output
	round_key <= key_state;

end round;
