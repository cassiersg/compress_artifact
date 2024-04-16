
library ieee;
use ieee.std_logic_1164.all;
use work.skinnypkg.all;

entity h0 is

port (a1, a2, a3 : in std_logic;
      b1, b2, b3 : in std_logic;
      c1, c2, c3 : in std_logic;
      d1, d2, d3 : in std_logic;
      e1, e2, e3 : in std_logic;
      f1, f2, f3 : in std_logic;
      g1, g2, g3 : in std_logic;
      h1, h2, h3 : in std_logic;

      y0, y1, y2, y3, y4, y5, y6, y7 : out std_logic);

end entity h0;

architecture word of h0 is begin
y0 <= (d1 and f1) xor (d1 and f2) xor (d1 and f3) xor (d1) xor (d2 and f1) xor (d2 and f3) xor (d3 and f1) xor (d3 and f2) xor (d3) xor (f2) xor (g1) xor ('1');
y1 <= (f1) xor (f3);
y2 <= (e1) xor (e3);
y3 <= (d1) xor (d3);
y4 <= (a1 and b1) xor (a1 and b2) xor (a1 and b3) xor (a1) xor (a2 and b1) xor (a2 and b3) xor (a3 and b1) xor (a3 and b2) xor (a3) xor (b2) xor (h1) xor ('1');
y5 <= (c1) xor (c3);
y6 <= (b1) xor (b3);
y7 <= (a1) xor (a3);

end architecture word;

