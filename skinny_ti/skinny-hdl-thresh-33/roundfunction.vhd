library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.skinnypkg.all;

attribute S          : string;
attribute KEEP       : string;
attribute SYN_KEEP   : string;

entity roundfunction is
  generic (ts : tweak_size := tweak_size_1n);
   port (clk        : in  std_logic;
         
         reset_n    : in std_logic;
         load0_init : in std_logic;
         load1_init : in std_logic;
         load2_init : in std_logic;
         load3_init : in std_logic;
         load_upd   : in std_logic;
        
         round_cst   : in std_logic_vector(5 downto 0);
         round_key   : in std_logic_vector((get_tweak_size(ts) - 1) downto 0);

         pt0, pt1, pt2, pt3 : in  std_logic_vector(127 downto 0);
         ct0, ct1, ct2, ct3 : out std_logic_vector(127 downto 0));
end roundfunction;

architecture round of roundfunction is

	constant w : integer := 8;
	constant n : integer := 128;
	constant t : integer := get_tweak_size(ts);

	signal state, state_next, substitute, addition, shiftrows : std_logic_vector((n - 1) downto 0);

    -- state signals
    signal s0, s1, s2, s3     : std_logic_vector((n - 1) downto 0);
    signal sn0, sn1, sn2, sn3 : std_logic_vector((n - 1) downto 0);

    signal sb0, sb1, sb2, sb3 : std_logic_vector((n - 1) downto 0);
    signal ka0, ka1, ka2, ka3 : std_logic_vector((n - 1) downto 0);
    signal sr0, sr1, sr2, sr3 : std_logic_vector((n - 1) downto 0);
    signal mc0, mc1, mc2, mc3 : std_logic_vector((n - 1) downto 0);

    attribute S        of s0, s1, s2, s3, sn0, sn1, sn2, s3, sb0, sb1, sb2, sb3, ka0, ka1, ka2, ka3, sr0, sr1, sr2, sr3, mc0, mc1, mc2, mc3  : signal is "true";
    attribute KEEP        of s0, s1, s2, s3, sn0, sn1, sn2, s3, sb0, sb1, sb2, sb3, ka0, ka1, ka2, ka3, sr0, sr1, sr2, sr3, mc0, mc1, mc2, mc3  : signal is "true";
    attribute SYN_KEEP        of s0, s1, s2, s3, sn0, sn1, sn2, s3, sb0, sb1, sb2, sb3, ka0, ka1, ka2, ka3, sr0, sr1, sr2, sr3, mc0, mc1, mc2, mc3  : signal is "true";

    attribute S        of sub : label is "true";
    attribute KEEP        of sub : label is "true";
    attribute SYN_KEEP        of sub : label is "true";

begin

	-- register stage
	reg0 : entity work.reg generic map (n => n) port map (clk, reset_n, load0_init, load_upd, pt0, sn0, s0);
	reg1 : entity work.reg generic map (n => n) port map (clk, reset_n, load1_init, load_upd, pt1, sn1, s1);
	reg2 : entity work.reg generic map (n => n) port map (clk, reset_n, load2_init, load_upd, pt2, sn2, s2);
	reg3 : entity work.reg generic map (n => n) port map (clk, reset_n, load3_init, load_upd, pt3, sn3, s3);

    -- substitution
    sub : entity work.substitution port map (clk, s0, s1, s2, s3, sb0, sb1, sb2, sb3);

	-- constant and key addition
	key0 : entity work.addconstkey generic map (ts => ts) port map (round_cst, round_key, sb0, ka0);
    ka1 <= sb1;
    ka2 <= sb2;
    ka3 <= sb3;

	-- shift rows
	shift0 : entity work.shiftrows port map (ka0, sr0);
	shift1 : entity work.shiftrows port map (ka1, sr1);
	shift2 : entity work.shiftrows port map (ka2, sr2);
	shift3 : entity work.shiftrows port map (ka3, sr3);

	-- mix columns
	mix0 : entity work.mixcolumns port map (sr0, mc0);
	mix1 : entity work.mixcolumns port map (sr1, mc1);
	mix2 : entity work.mixcolumns port map (sr2, mc2);
	mix3 : entity work.mixcolumns port map (sr3, mc3);

    sn0 <= mc0;
    sn1 <= mc1;
    sn2 <= mc2;
    sn3 <= mc3;

    ct0 <= s0;
    ct1 <= s1;
    ct2 <= s2;
    ct3 <= s3;

end round;
