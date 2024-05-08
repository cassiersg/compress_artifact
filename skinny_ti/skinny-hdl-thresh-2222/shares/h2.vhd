
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

      y0, y1, y2, y3, y4, y5, y6, y7 : out std_logic);

end entity h2;

architecture word of h2 is begin
y0 <= (a1);
y1 <= (b1);
y2 <= (c1);
y3 <= (c0 and g1) xor (c1 and g0) xor (e0) xor (e1);
y4 <= (d1);
y5 <= (a0 and d1) xor (a1 and d0) xor (d0) xor (d1);
y6 <= (f1);
y7 <= (g1);

end architecture word;

