
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

      y0, y1, y2, y3, y4, y5, y6, y7 : out std_logic);

end entity g0;

architecture word of g0 is begin
y0 <= (a1 and b1) xor (a1 and b2) xor (a1 and b3) xor (a1) xor (a2 and b3) xor (b1) xor (g1) xor ('1');
y1 <= (a1);
y2 <= (b1);
y3 <= (c1);
y4 <= (d1);
y5 <= (a1 and b1 and d1) xor (a1 and b1 and d2) xor (a1 and b1 and d3) xor (a1 and b1) xor (a1 and b2 and d1) xor (a1 and b2 and d2) xor (a1 and b2 and d3) xor (a1 and b2) xor (a1 and b3 and d1) xor (a1 and b3 and d2) xor (a1 and b3 and d3) xor (a1 and b3) xor (a1 and d1) xor (a1 and d3) xor (a1) xor (a2 and b1 and d1) xor (a2 and b1 and d3) xor (a2 and b2 and d1) xor (a2 and b3 and d1) xor (a2 and b3 and d3) xor (a2 and d3) xor (a3 and b1 and d2) xor (a3 and b2 and d1) xor (a3 and b2 and d3) xor (a3 and b3 and d2) xor (a3 and d1) xor (b1 and d2) xor (b1 and d3) xor (b1) xor (b2 and d3) xor (d1 and g1) xor (d1 and g2) xor (d1 and g3) xor (d2 and g3) xor (d3 and g3) xor (g1) xor (h1);
y6 <= (e1);
y7 <= (f1);

end architecture word;

