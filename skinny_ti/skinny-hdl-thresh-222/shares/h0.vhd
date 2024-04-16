
library ieee;
use ieee.std_logic_1164.all;
use work.skinnypkg.all;

entity h0 is

port (a1, a2 : in std_logic;
      b1, b2 : in std_logic;
      c1, c2 : in std_logic;
      d1, d2 : in std_logic;
      e1, e2 : in std_logic;
      f1, f2 : in std_logic;
      g1, g2 : in std_logic;
      h1, h2 : in std_logic;
      i1, i2 : in std_logic;

      y0, y1, y2, y3, y4, y5, y6, y7 : out std_logic);

end entity h0;

architecture word of h0 is begin
y0 <= (h1) xor (a1 and c2) xor (a1 and f1) xor (a1 and f2) xor (a1 and g1) xor (a1 and g2) xor (a1) xor (a2 and c1) xor (a2 and f1) xor (a2 and f2) xor (a2 and g1) xor (a2) xor (f1 and i1) xor (f1 and i2) xor (f2 and i1) xor (g1) xor (g2) xor (i2);
y1 <= (a1 and g2) xor (a1) xor (a2 and g1) xor (a2 and g2) xor (a2) xor (i2) xor ('1');
y2 <= (g2);
y3 <= (f2);
y4 <= (b2);
y5 <= (e2);
y6 <= (d2);
y7 <= (a2);

end architecture word;

