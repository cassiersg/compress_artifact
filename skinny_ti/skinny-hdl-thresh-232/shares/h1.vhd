
library ieee;
use ieee.std_logic_1164.all;
use work.skinnypkg.all;

entity h1 is

port (a0, a3 : in std_logic;
      b0, b3 : in std_logic;
      c0, c3 : in std_logic;
      d0, d3 : in std_logic;
      e0, e3 : in std_logic;
      f0, f3 : in std_logic;
      g0, g3 : in std_logic;
      h0, h3 : in std_logic;

      y0, y1, y2, y3, y4, y5, y6, y7 : out std_logic);

end entity h1;

architecture word of h1 is begin
y0 <= (d0 and f0) xor (d0 and f3) xor (d0) xor (d3 and f0) xor (d3 and f3) xor (f0) xor (f3) xor (g3);
y1 <= (f0);
y2 <= (e0);
y3 <= (d0);
y4 <= (a0 and b0) xor (a0 and b3) xor (a0) xor (a3 and b0) xor (a3 and b3) xor (b0) xor (b3) xor (h3);
y5 <= (c0);
y6 <= (b0);
y7 <= (a0);

end architecture word;

