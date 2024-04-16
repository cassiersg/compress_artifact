
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
      i0, i1, i2 : in std_logic;

      y0, y1, y2, y3, y4, y5, y6, y7 : out std_logic);

end entity g3;

architecture word of g3 is begin
y0 <= (a0 and b0 and d2) xor (a0 and b1 and d0) xor (a0 and b1 and d2) xor (a0 and b1) xor (a0 and b2 and d1) xor (a0 and c0 and d0) xor (a0 and c0 and d1) xor (a0 and c0 and d2) xor (a0 and c1 and d1) xor (a0 and c1 and d2) xor (a0 and c2 and d1) xor (a0 and c2) xor (a0 and d0 and e0) xor (a0 and d0 and e1) xor (a0 and d0) xor (a0 and d1 and e1) xor (a0 and d1 and e2) xor (a0 and d2 and e1) xor (a0 and e0) xor (a0 and e1) xor (a0 and e2) xor (a1 and b0 and d1) xor (a1 and b0 and d2) xor (a1 and b1 and d0) xor (a1 and b2 and d0) xor (a1 and c0 and d1) xor (a1 and c0 and d2) xor (a1 and c1 and d0) xor (a1 and c2 and d0) xor (a1 and d0 and e1) xor (a1 and d0 and e2) xor (a1 and d1 and e0) xor (a1 and d2 and e0) xor (a1 and e0) xor (a1 and e2) xor (a2 and b0 and d1) xor (a2 and b1 and d0) xor (a2 and b1 and d2) xor (a2 and b1) xor (a2 and c0 and d1) xor (a2 and c1 and d0) xor (a2 and c1 and d2) xor (a2 and c1) xor (a2 and d0 and e0) xor (a2 and d0 and e1) xor (a2 and d0 and e2) xor (a2 and d0) xor (a2 and d1 and e0) xor (a2 and d1) xor (a2 and d2) xor (a2 and e0) xor (a2 and e1) xor (a2) xor (b0 and c0) xor (b0 and c1) xor (b0 and c2) xor (b0 and d0) xor (b0 and d1) xor (b0 and d2) xor (b1 and c0) xor (b1 and c1) xor (b1 and c2) xor (b1 and d0) xor (b1 and d1) xor (b1 and d2) xor (b2 and c0) xor (b2 and c1) xor (b2 and c2) xor (b2 and d0) xor (b2 and d1) xor (b2 and d2) xor (b2) xor (c0 and d0 and h0) xor (c0 and d0 and h1) xor (c0 and d1 and h0) xor (c0 and d1 and h2) xor (c0 and d2 and h1) xor (c0 and h0) xor (c0 and h1) xor (c0 and h2) xor (c0 and i1) xor (c1 and d0 and h0) xor (c1 and d0 and h2) xor (c1 and d1 and h0) xor (c1 and d2 and h0) xor (c1 and i0) xor (c1 and i2) xor (c2 and d0 and h1) xor (c2 and d1 and h0) xor (c2 and d1 and h2) xor (c2 and d2 and h1) xor (c2 and h0) xor (c2 and i0) xor (c2 and i1) xor (c2) xor (d0 and e0) xor (d0 and e1) xor (d0 and e2) xor (d0 and h0) xor (d0 and h1) xor (d0 and h2) xor (d1 and h0) xor (d1 and h2) xor (d2 and e1) xor (d2 and h1) xor (f2) xor (h2) xor (i2);
y1 <= (a0 and b0 and d2) xor (a0 and b1 and d0) xor (a0 and b1 and d2) xor (a0 and b1) xor (a0 and b2 and d1) xor (a0 and d0) xor (a0 and d1) xor (a0 and d2) xor (a1 and b0 and d1) xor (a1 and b0 and d2) xor (a1 and b1 and d0) xor (a1 and b2 and d0) xor (a1 and d2) xor (a2 and b0 and d1) xor (a2 and b1 and d0) xor (a2 and b1 and d2) xor (a2 and b1) xor (a2 and d0) xor (a2 and d1) xor (a2 and d2) xor (a2) xor (b0 and d0) xor (b0 and d1) xor (b0 and d2) xor (b1 and d0) xor (b1 and d1) xor (b2 and d0) xor (b2 and d1) xor (b2) xor (d0 and h0) xor (d0 and h1) xor (d2 and h0) xor (d2 and h1) xor (h2) xor (i2);
y2 <= (d2);
y3 <= (c2);
y4 <= (a0 and b2) xor (a0 and h1) xor (a1 and b0) xor (a1 and h2) xor (a2 and b1) xor (a2 and h1) xor (b2) xor (g2) xor (h2);
y5 <= (b2);
y6 <= (a2);
y7 <= (a0 and b2) xor (a2 and b0) xor (a2 and b1) xor (a2) xor (b2) xor (h2);

end architecture word;

