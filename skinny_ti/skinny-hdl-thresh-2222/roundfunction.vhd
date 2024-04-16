library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.skinnypkg.all;

entity roundfunction is
  generic (ts : tweak_size := tweak_size_1n);
   port (clk        : in  std_logic;
         reset      : in  std_logic;
        
         round_epoch : in unsigned(1 downto 0);
         round_cst   : in std_logic_vector(5 downto 0);
         round_key   : in std_logic_vector((get_tweak_size(ts) - 1) downto 0);

         ri0, ri1, ri2 : in  std_logic_vector(127 downto 0);
         ro0, ro1, ro2 : out std_logic_vector(127 downto 0));
end roundfunction;

architecture round of roundfunction is

	constant w : integer := 8;
	constant n : integer := 128;
	constant t : integer := get_tweak_size(ts);

	signal state, state_next, substitute, addition, shiftrows : std_logic_vector((n - 1) downto 0);

    -- state signals
    signal s0, s1, s2    : std_logic_vector((n - 1) downto 0);
    signal sn0, sn1, sn2 : std_logic_vector((n - 1) downto 0);

    signal sb0, sb1, sb2 : std_logic_vector((n - 1) downto 0);
    signal ka0, ka1, ka2 : std_logic_vector((n - 1) downto 0);
    signal sr0, sr1, sr2 : std_logic_vector((n - 1) downto 0);
    signal mc0, mc1, mc2 : std_logic_vector((n - 1) downto 0);

begin

	-- register stage
	reg0 : entity work.statereg generic map (n => n) port map (clk, reset, sn0, ri0, s0);
	reg1 : entity work.statereg generic map (n => n) port map (clk, reset, sn1, ri1, s1);
	reg2 : entity work.statereg generic map (n => n) port map (clk, reset, sn2, ri2, s2);

    -- substitution
    sub : entity work.substitution port map (clk, s0, s1, s2, sb0, sb1, sb2);

	-- constant and key addition
	key0 : entity work.addconstkey generic map (ts => ts) port map (round_cst, round_key, sb0, ka0);
	key1 : entity work.addconstkey generic map (ts => ts) port map (round_cst, round_key, sb1, ka1);
	key2 : entity work.addconstkey generic map (ts => ts) port map (round_cst, round_key, sb2, ka2);

	-- shift rows
	shift0 : entity work.shiftrows port map (ka0, sr0);
	shift1 : entity work.shiftrows port map (ka1, sr1);
	shift2 : entity work.shiftrows port map (ka2, sr2);

	-- mix columns
	mix0 : entity work.mixcolumns port map (sr0, mc0);
	mix1 : entity work.mixcolumns port map (sr1, mc1);
	mix2 : entity work.mixcolumns port map (sr2, mc2);

    sn0 <= mc0;
    sn1 <= mc1;
    sn2 <= mc2;

    ro0 <= sn0;
    ro1 <= sn1;
    ro2 <= sn2;

end round;
