
library ieee;
use ieee.std_logic_1164.all;
use work.skinnypkg.all;

entity f2 is

port (a0, a1 : in std_logic;
      b0, b1 : in std_logic;
      c0, c1 : in std_logic;
      d0, d1 : in std_logic;
      e0, e1 : in std_logic;
      f0, f1 : in std_logic;
      g0, g1 : in std_logic;
      h0, h1 : in std_logic;

      y0, y1, y2, y3, y4, y5, y6, y7 : out std_logic);

end entity f2;

architecture word of f2 is begin
y0 <= (g0 and h0) xor (g0 and h1) xor (g0) xor (g1 and h0) xor (g1);
y1 <= (c0 and d0) xor (c0 and d1) xor (c0) xor (c1 and d0) xor (c1);
y2 <= (b1);
y3 <= (c1);
y4 <= (d1);
y5 <= (f1);
y6 <= (g1);
y7 <= (h1);

end architecture word;

