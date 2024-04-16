library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.skinnypkg.all;

entity skinny is
    generic (ts : tweak_size := tweak_size_1n);
    port (clk   : in  std_logic;
         
          -- configuration signals 
          reset_n : in std_logic; -- active-low synchronous
          key_rdy : in std_logic; -- load key
          pt0_rdy : in std_logic; -- load plaintext 0
          pt1_rdy : in std_logic; -- load plaintext 1
          pt2_rdy : in std_logic; -- load plaintext 2
          pt3_rdy : in std_logic; -- load plaintext 2
          start   : in std_logic; -- trigger encryption
         
          busy    : out std_logic; -- indicator for ongoing encryption
          done    : out std_logic; -- indicator for encryption end
           
          key                : in std_logic_vector((get_tweak_size(ts)-1) downto 0);
          pt0, pt1, pt2, pt3 : in std_logic_vector(127 downto 0);

          ct0, ct1, ct2, ct3 : out std_logic_vector(127 downto 0));
end skinny;

architecture structural of skinny is

	signal round_key   : std_logic_vector((get_tweak_size(ts) - 1) downto 0);
	signal round_cst   : std_logic_vector(5 downto 0);

    signal load_upd : std_logic;

begin

    rf : entity work.roundfunction generic map (ts => ts) port map (
        clk        => clk,
        reset_n    => reset_n,
        load0_init => pt0_rdy,
        load1_init => pt1_rdy,
        load2_init => pt2_rdy,
        load3_init => pt3_rdy,
        load_upd   => load_upd,
        round_cst  => round_cst,
        round_key  => round_key,
        pt0        => pt0,
        pt1        => pt1,
        pt2        => pt2,
        pt3        => pt3,
        ct0        => ct0,
        ct1        => ct1,
        ct2        => ct2,
        ct3        => ct3
    );

    ke : entity work.keyexpansion  generic map (ts => ts) port map (
        clk       => clk,
        reset_n   => reset_n,
        load_init => key_rdy,
        load_upd  => load_upd,
        key       => key,
        round_key => round_key
    );
    
    cl : entity work.controller port map (
        clk       => clk,
        reset_n   => reset_n,
        start     => start,
        busy      => busy,
        done      => done,
        load_upd  => load_upd,
        round_cst => round_cst
    );

end structural;
