
library ieee;
use ieee.std_logic_1164.all;
use work.skinnypkg.all;

entity f0 is

port (a1, a2, a3 : in std_logic;
      b1, b2, b3 : in std_logic;
      c1, c2, c3 : in std_logic;
      d1, d2, d3 : in std_logic;
      e1, e2, e3 : in std_logic;
      f1, f2, f3 : in std_logic;
      g1, g2, g3 : in std_logic;
      h1, h2, h3 : in std_logic;

      y0, y1, y2, y3, y4, y5, y6, y7, y8 : out std_logic);

end entity f0;

architecture word of f0 is begin
y0 <= (e1) xor (g1 and h1) xor (g1 and h2) xor (g1 and h3) xor (g1) xor (g2 and h3) xor (h1) xor ('1');
y1 <= (a1) xor (c1 and d1) xor (c1 and d2) xor (c1 and d3) xor (c1) xor (c2 and d3) xor (d1) xor ('1');
y2 <= (a1 and d1) xor (a1 and d2) xor (a1 and d3) xor (a1) xor (a2 and d3) xor (b1) xor (c1 and d1) xor (c1 and d2) xor (c1 and d3) xor (c1) xor (c2 and d3);
y3 <= (b1 and c1) xor (b1 and c2) xor (b1 and c3) xor (b1) xor (b2 and c3) xor (c1) xor (g1) xor ('1');
y4 <= (h3) xor (e1) xor (a1 and b1) xor (a1 and b2) xor (a1 and b3) xor (a2 and b3) xor (a3 and b3) xor (b1 and c1 and d1) xor (b1 and c1 and d2) xor (b1 and c1 and d3) xor (b1 and c1) xor (b1 and c2 and d1) xor (b1 and c2 and d2) xor (b1 and c2 and d3) xor (b1 and c2) xor (b1 and c3 and d1) xor (b1 and c3 and d2) xor (b1 and c3 and d3) xor (b1 and c3) xor (b1 and d3) xor (b1) xor (b2 and c1 and d1) xor (b2 and c1 and d3) xor (b2 and c2 and d1) xor (b2 and c3 and d1) xor (b2 and c3 and d3) xor (b2 and d3) xor (b3 and c1 and d2) xor (b3 and c2 and d1) xor (b3 and c2 and d3) xor (b3 and c3 and d2) xor (b3 and d1);
y5 <= (c1);
y6 <= (d1);
y7 <= (f1);
y8 <= (h1);

end architecture word;

