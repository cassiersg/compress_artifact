library ieee;
use ieee.std_logic_1164.all;

use work.skinnypkg.all;

entity substitution is
	port (clk        : in  std_logic;
          x0, x1, x2 : in  std_logic_vector(127 downto 0);
          y0, y1, y2 : out std_logic_vector(127 downto 0));
end substitution;

architecture structural of substitution is
    signal f0, f1, f2, f3 : std_logic_vector(127 downto 0);
    signal g0, g1, g2, g3 : std_logic_vector(127 downto 0);
    signal h0, h1, h2, h3 : std_logic_vector(143 downto 0);
    signal w0, w1, w2, w3 : std_logic_vector(143 downto 0);
begin

    p0 : entity work.pipereg generic map (128) port map (clk, f0, g0);
    p1 : entity work.pipereg generic map (128) port map (clk, f1, g1);
    p2 : entity work.pipereg generic map (128) port map (clk, f2, g2);
    
    q0 : entity work.pipereg generic map (144) port map (clk, h0, w0);
    q1 : entity work.pipereg generic map (144) port map (clk, h1, w1);
    q2 : entity work.pipereg generic map (144) port map (clk, h2, w2);

    fgen : for i in 0 to 15 generate
        sbox : entity work.f port map(
            x0(8*(i+1)-1 downto 8*i),
            x1(8*(i+1)-1 downto 8*i),
            x2(8*(i+1)-1 downto 8*i),
    
            f0(8*(i+1)-1 downto 8*i),
            f1(8*(i+1)-1 downto 8*i),
            f2(8*(i+1)-1 downto 8*i)
        );
    end generate;
    
    ggen : for i in 0 to 15 generate
        sbox : entity work.g port map(
            g0(8*(i+1)-1 downto 8*i),
            g1(8*(i+1)-1 downto 8*i),
            g2(8*(i+1)-1 downto 8*i),
            
            h0(9*(i+1)-1 downto 9*i),
            h1(9*(i+1)-1 downto 9*i),
            h2(9*(i+1)-1 downto 9*i)
        );
    end generate;
    
    hgen : for i in 0 to 15 generate
        sbox : entity work.h port map(
            w0(9*(i+1)-1 downto 9*i),
            w1(9*(i+1)-1 downto 9*i),
            w2(9*(i+1)-1 downto 9*i),
    
            y0(8*(i+1)-1 downto 8*i),
            y1(8*(i+1)-1 downto 8*i),
            y2(8*(i+1)-1 downto 8*i)
        );
    end generate;

end structural;

