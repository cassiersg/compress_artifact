
library ieee;
use ieee.std_logic_1164.all;
use work.skinnypkg.all;

entity f1 is

port (a0, a2 : in std_logic;
      b0, b2 : in std_logic;
      c0, c2 : in std_logic;
      d0, d2 : in std_logic;
      e0, e2 : in std_logic;
      f0, f2 : in std_logic;
      g0, g2 : in std_logic;
      h0, h2 : in std_logic;

      y0, y1, y2, y3, y4, y5, y6, y7 : out std_logic);

end entity f1;

architecture word of f1 is begin
y0 <= (e0) xor (g0 and h2) xor (g2 and h0) xor (g2 and h2) xor (g2) xor (h2);
y1 <= (a0) xor (c0 and d2) xor (c2 and d0) xor (c2 and d2) xor (c2) xor (d2);
y2 <= (a0 and d0) xor (a0 and d2) xor (a0) xor (a2 and d0) xor (b2) xor (c0 and d2) xor (c2 and d0) xor (c2 and d2) xor (c2);
y3 <= (b0 and c0) xor (b0 and c2) xor (b0) xor (b2 and c0) xor (c2) xor (g2);
y4 <= (c0) xor (a0);
y5 <= (d0) xor (a0);
y6 <= (f0) xor (a0);
y7 <= (h0) xor (a0);

end architecture word;

