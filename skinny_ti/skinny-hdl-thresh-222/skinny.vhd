library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.skinnypkg.all;

entity skinny is
    generic (ts : tweak_size := tweak_size_1n);
    port (clk   : in  std_logic;
          reset : in  std_logic;
          done  : out std_logic;
           
          key : in  std_logic_vector((get_tweak_size(ts)-1) downto 0);

          pt0, pt1, pt2 : in  std_logic_vector(127 downto 0);
          ct0, ct1, ct2 : out std_logic_vector(127 downto 0));
end skinny;

architecture structural of skinny is

	signal round_key   : std_logic_vector((get_tweak_size(ts) - 1) downto 0);
	signal round_cst   : std_logic_vector(5 downto 0);
    signal round_epoch : unsigned(1 downto 0);

begin

   rf : entity work.roundfunction generic map (ts => ts) port map (
       clk, reset, round_epoch, round_cst, round_key, pt0, pt1, pt2, ct0, ct1, ct2
   );

   ke : entity work.keyexpansion  generic map (ts => ts) port map (clk, reset, key, round_epoch, round_key);
   cl : entity work.controller    generic map (ts => ts) port map (clk, reset, done, round_cst, round_epoch);

end structural;
