
library ieee;
use ieee.std_logic_1164.all;
use work.skinnypkg.all;

entity h1 is

port (a0, a2 : in std_logic;
      b0, b2 : in std_logic;
      c0, c2 : in std_logic;
      d0, d2 : in std_logic;
      e0, e2 : in std_logic;
      f0, f2 : in std_logic;
      g0, g2 : in std_logic;
      h0, h2 : in std_logic;
      i0, i2 : in std_logic;

      y0, y1, y2, y3, y4, y5, y6, y7 : out std_logic);

end entity h1;

architecture word of h1 is begin
y0 <= (a0 and c0) xor (a0 and c2) xor (a0 and f2) xor (a0 and g0) xor (a0 and g2) xor (a0) xor (a2 and c0) xor (a2 and c2) xor (a2 and f0) xor (a2 and g0) xor (a2 and g2) xor (c2) xor (f0 and i2) xor (f2 and i0) xor (f2 and i2) xor (h2) xor (i0);
y1 <= (a0 and g0) xor (a0 and g2) xor (a0) xor (a2 and g0) xor (g2) xor (i0);
y2 <= (g0);
y3 <= (f0);
y4 <= (b0);
y5 <= (e0);
y6 <= (d0);
y7 <= (a0);

end architecture word;

