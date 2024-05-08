
library ieee;
use ieee.std_logic_1164.all;
use work.skinnypkg.all;

entity i1 is

port (a0, a2 : in std_logic;
      b0, b2 : in std_logic;
      c0, c2 : in std_logic;
      d0, d2 : in std_logic;
      e0, e2 : in std_logic;
      f0, f2 : in std_logic;
      g0, g2 : in std_logic;
      h0, h2 : in std_logic;

      y0, y1, y2, y3, y4, y5, y6, y7 : out std_logic);

end entity i1;

architecture word of i1 is begin
y0 <= (d0 and f0) xor (d0 and f2) xor (d0) xor (d2 and f0) xor (f2) xor (g0);
y1 <= (f0);
y2 <= (e0);
y3 <= (d0);
y4 <= (a0 and b0) xor (a0 and b2) xor (a0) xor (a2 and b0) xor (b2) xor (h0);
y5 <= (c0);
y6 <= (b0);
y7 <= (a0);

end architecture word;

