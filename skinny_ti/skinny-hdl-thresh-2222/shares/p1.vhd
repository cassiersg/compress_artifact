library ieee;
use ieee.std_logic_1164.all;

use work.skinnypkg.all;

entity p1 is
    port (a0, a2 : in std_logic;
          b0, b2 : in std_logic;
          c0, c2 : in std_logic;
          d0, d2 : in std_logic;
          e0, e2 : in std_logic;
          f0, f2 : in std_logic;
          g0, g2 : in std_logic;
          h0, h2 : in std_logic;

          y0, y1, y2, y3, y4, y5, y6, y7 : out std_logic);
end p1;

architecture word of p1 is
begin

    y0 <= (f2);

    y1 <= (d2);
    
    y2 <= (a2) xor (c0 and d0) xor (c0 and d2) xor (c2 and d0) xor (c2) xor (d2);
    
    y3 <= (e2) xor (g0 and h0) xor (g0 and h2) xor (g2 and h0) xor (g2) xor (h2);
    
    y4 <= (g2);
    
    y5 <= (h2);
    
    y6 <= (b2);
    
    y7 <= (c2);

end word;
