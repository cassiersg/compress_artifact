library ieee;
use ieee.std_logic_1164.all;

use work.skinnypkg.all;

entity p0 is
    port (a1, a2 : in std_logic;
          b1, b2 : in std_logic;
          c1, c2 : in std_logic;
          d1, d2 : in std_logic;
          e1, e2 : in std_logic;
          f1, f2 : in std_logic;
          g1, g2 : in std_logic;
          h1, h2 : in std_logic;

          y0, y1, y2, y3, y4, y5, y6, y7 : out std_logic);
end p0;

architecture word of p0 is
begin

    y0 <= (f1);
    
    y1 <= (d1);
    
    y2 <= (a1) xor (c1 and d1) xor (c1 and d2) xor (c1) xor (c2 and d1) xor (c2 and d2) xor (d1) xor ('1');
    
    y3 <= (e1) xor (g1 and h1) xor (g1 and h2) xor (g1) xor (g2 and h1) xor (g2 and h2) xor (h1) xor ('1');
    
    y4 <= (g1);
    
    y5 <= (h1);
    
    y6 <= (b1);
    
    y7 <= (c1);

end word;
