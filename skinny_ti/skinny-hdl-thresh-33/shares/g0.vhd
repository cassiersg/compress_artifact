
library ieee;
use ieee.std_logic_1164.all;
use work.skinnypkg.all;

entity g0 is

port (a1, a2, a3 : in std_logic;
      b1, b2, b3 : in std_logic;
      c1, c2, c3 : in std_logic;
      d1, d2, d3 : in std_logic;
      e1, e2, e3 : in std_logic;
      f1, f2, f3 : in std_logic;
      g1, g2, g3 : in std_logic;
      h1, h2, h3 : in std_logic;
      i1, i2, i3 : in std_logic;

      y0, y1, y2, y3, y4, y5, y6, y7 : out std_logic);

end entity g0;

architecture word of g0 is begin
y0 <= (a1 and b1 and d1) xor (a1 and b1 and d2) xor (a1 and b1 and d3) xor (a1 and b1) xor (a1 and b2 and d1) xor (a1 and b2 and d2) xor (a1 and b2 and d3) xor (a1 and b2) xor (a1 and b3 and d1) xor (a1 and b3 and d2) xor (a1 and b3 and d3) xor (a1 and b3) xor (a1 and c1 and d1) xor (a1 and c1 and d2) xor (a1 and c1 and d3) xor (a1 and c1) xor (a1 and c2 and d1) xor (a1 and c2 and d2) xor (a1 and c2 and d3) xor (a1 and c2) xor (a1 and c3 and d1) xor (a1 and c3 and d2) xor (a1 and c3 and d3) xor (a1 and c3) xor (a1 and d1 and e1) xor (a1 and d1 and e2) xor (a1 and d1 and e3) xor (a1 and d1) xor (a1 and d2 and e1) xor (a1 and d2 and e2) xor (a1 and d2 and e3) xor (a1 and d2) xor (a1 and d3 and e1) xor (a1 and d3 and e2) xor (a1 and d3) xor (a1 and e3) xor (a1) xor (a2 and b1 and d1) xor (a2 and b1 and d3) xor (a2 and b2 and d1) xor (a2 and b3 and d1) xor (a2 and c1 and d1) xor (a2 and c1 and d3) xor (a2 and c2 and d1) xor (a2 and c3 and d1) xor (a2 and c3 and d3) xor (a2 and d1 and e1) xor (a2 and d1 and e2) xor (a2 and d1 and e3) xor (a2 and d2 and e1) xor (a2 and d3 and e1) xor (a2 and d3 and e2) xor (a2 and d3) xor (a2 and e3) xor (a3 and b1 and d2) xor (a3 and b2 and d1) xor (a3 and b2 and d3) xor (a3 and b3 and d2) xor (a3 and c1 and d2) xor (a3 and c2 and d1) xor (a3 and c2 and d3) xor (a3 and c3 and d2) xor (a3 and d1 and e1) xor (a3 and d1 and e2) xor (a3 and d1) xor (a3 and d2 and e1) xor (a3 and d2) xor (a3 and d3) xor (a3 and e2) xor (b1 and c3) xor (b1 and d3) xor (b1) xor (b2 and d3) xor (b3 and d1) xor (b3 and d2) xor (c1 and d1 and h1) xor (c1 and d1 and h2) xor (c1 and d1 and h3) xor (c1 and d2 and h1) xor (c1 and d2 and h2) xor (c1 and d2 and h3) xor (c1 and d3 and h1) xor (c1 and d3 and h2) xor (c1 and d3 and h3) xor (c1 and h1) xor (c1 and h2) xor (c1 and h3) xor (c1 and i3) xor (c1) xor (c2 and d1 and h1) xor (c2 and d1 and h3) xor (c2 and d3 and h1) xor (c2 and h1) xor (c2 and h3) xor (c2 and i3) xor (c3 and d1 and h2) xor (c3 and d2 and h1) xor (c3 and d2 and h3) xor (c3 and h2) xor (c3 and i1) xor (d1 and e1) xor (d1 and e2) xor (d1 and e3) xor (d1 and h3) xor (d2 and e3) xor (d2 and h2) xor (d3 and e2) xor (d3 and h2) xor (f1) xor (h1) xor (i1) xor ('1');
y1 <= (a1 and b1 and d1) xor (a1 and b1 and d2) xor (a1 and b1 and d3) xor (a1 and b1) xor (a1 and b2 and d1) xor (a1 and b2 and d2) xor (a1 and b2 and d3) xor (a1 and b2) xor (a1 and b3 and d1) xor (a1 and b3 and d2) xor (a1 and b3 and d3) xor (a1 and b3) xor (a1 and d1) xor (a1 and d3) xor (a1) xor (a2 and b1 and d1) xor (a2 and b1 and d3) xor (a2 and b2 and d1) xor (a2 and b3 and d1) xor (a2 and b3 and d3) xor (a2 and d3) xor (a3 and b1 and d2) xor (a3 and b2 and d1) xor (a3 and b2 and d3) xor (a3 and b3 and d2) xor (a3 and d1) xor (b1 and d2) xor (b1 and d3) xor (b1) xor (b2 and d3) xor (d1 and h1) xor (d1 and h2) xor (d1 and h3) xor (d2 and h3) xor (d3 and h3) xor (h1) xor (i1);
y2 <= (d1);
y3 <= (c1);
y4 <= (a1 and b1) xor (a1 and b2) xor (a1 and b3) xor (a1 and h1) xor (a1 and h3) xor (a2 and b3) xor (a2 and h2) xor (a3 and b2) xor (a3 and h2) xor (b1) xor (g1) xor (h1);
y5 <= (b1);
y6 <= (a1);
y7 <= (a1 and b1) xor (a1 and b2) xor (a1 and b3) xor (a1) xor (a2 and b3) xor (b1) xor (h1) xor ('1');

end architecture word;

