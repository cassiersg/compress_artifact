
library ieee;
use ieee.std_logic_1164.all;
use work.skinnypkg.all;

entity h2 is

port (a0, a1, a2 : in std_logic;
      b0, b1, b2 : in std_logic;
      c0, c1, c2 : in std_logic;
      d0, d1, d2 : in std_logic;
      e0, e1, e2 : in std_logic;
      f0, f1, f2 : in std_logic;
      g0, g1, g2 : in std_logic;
      h0, h1, h2 : in std_logic;

      y0, y1, y2, y3, y4, y5, y6, y7 : out std_logic);

end entity h2;

architecture word of h2 is begin
y0 <= (d0 and f1) xor (d0 and f2) xor (d1 and f0) xor (d2 and f0) xor (d2 and f2) xor (d2) xor (f1) xor (g0) xor (g2);
y1 <= (f2);
y2 <= (e2);
y3 <= (d2);
y4 <= (a0 and b1) xor (a0 and b2) xor (a1 and b0) xor (a2 and b0) xor (a2 and b2) xor (a2) xor (b1) xor (h0) xor (h2);
y5 <= (c2);
y6 <= (b2);
y7 <= (a2);

end architecture word;

