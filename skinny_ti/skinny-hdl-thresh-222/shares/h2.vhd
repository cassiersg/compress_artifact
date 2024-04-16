
library ieee;
use ieee.std_logic_1164.all;
use work.skinnypkg.all;

entity h2 is

port (a0, a1 : in std_logic;
      b0, b1 : in std_logic;
      c0, c1 : in std_logic;
      d0, d1 : in std_logic;
      e0, e1 : in std_logic;
      f0, f1 : in std_logic;
      g0, g1 : in std_logic;
      h0, h1 : in std_logic;
      i0, i1 : in std_logic;

      y0, y1, y2, y3, y4, y5, y6, y7 : out std_logic);

end entity h2;

architecture word of h2 is begin
y0 <= (g0) xor (i1) xor (a1 and c1) xor (a0 and c1) xor (a0 and f0) xor (a0 and f1) xor (a0 and g1) xor (a1 and c0) xor (a1 and f0) xor (a1 and g0) xor (c0) xor (c1) xor (f0 and i0) xor (f0 and i1) xor (f1 and i0) xor (h0);
y1 <= (i1) xor (a1 and g1) xor (a0 and g1) xor (a1 and g0) xor (g0) xor (g1);
y2 <= (g1);
y3 <= (f1);
y4 <= (b1);
y5 <= (e1);
y6 <= (d1);
y7 <= (a1);

end architecture word;

