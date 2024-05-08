
library ieee;
use ieee.std_logic_1164.all;
use work.skinnypkg.all;

entity g3 is

port (a0, a1, a2 : in std_logic;
      b0, b1, b2 : in std_logic;
      c0, c1, c2 : in std_logic;
      d0, d1, d2 : in std_logic;
      e0, e1, e2 : in std_logic;
      f0, f1, f2 : in std_logic;
      g0, g1, g2 : in std_logic;
      h0, h1, h2 : in std_logic;

      y0, y1, y2, y3, y4, y5, y6, y7 : out std_logic);

end entity g3;

architecture word of g3 is begin
y0 <= (a0 and b2) xor (a2 and b0) xor (a2 and b1) xor (a2) xor (b2) xor (g2);
y1 <= (a2);
y2 <= (b2);
y3 <= (c2);
y4 <= (d2);
y5 <= (a0 and b0 and d2) xor (a0 and b1 and d0) xor (a0 and b1 and d2) xor (a0 and b1) xor (a0 and b2 and d1) xor (a0 and d0) xor (a0 and d1) xor (a0 and d2) xor (a1 and b0 and d1) xor (a1 and b0 and d2) xor (a1 and b1 and d0) xor (a1 and b2 and d0) xor (a1 and d2) xor (a2 and b0 and d1) xor (a2 and b1 and d0) xor (a2 and b1 and d2) xor (a2 and b1) xor (a2 and d0) xor (a2 and d1) xor (a2 and d2) xor (a2) xor (b0 and d0) xor (b0 and d1) xor (b0 and d2) xor (b1 and d0) xor (b1 and d1) xor (b2 and d0) xor (b2 and d1) xor (b2) xor (d0 and g0) xor (d0 and g1) xor (d2 and g0) xor (d2 and g1) xor (g2) xor (h2);
y6 <= (e2);
y7 <= (f2);

end architecture word;

