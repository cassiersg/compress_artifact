library ieee;
use ieee.std_logic_1164.all;

use work.skinnypkg.all;

entity p2 is
    port (a0, a1 : in std_logic;
          b0, b1 : in std_logic;
          c0, c1 : in std_logic;
          d0, d1 : in std_logic;
          e0, e1 : in std_logic;
          f0, f1 : in std_logic;
          g0, g1 : in std_logic;
          h0, h1 : in std_logic;

          y0, y1, y2, y3, y4, y5, y6, y7 : out std_logic);
end p2;

architecture word of p2 is
begin

    y0 <= (f0);
    
    y1 <= (d0);
    
    y2 <= (a0) xor (c0 and d1) xor (c0) xor (c1 and d0) xor (d0);
    
    y3 <= (e0) xor (g0 and h1) xor (g0) xor (g1 and h0) xor (h0);
    
    y4 <= (g0);
    
    y5 <= (h0);
    
    y6 <= (b0);
    
    y7 <= (c0);

end word;
