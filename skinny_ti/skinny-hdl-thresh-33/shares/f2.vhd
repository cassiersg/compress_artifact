
library ieee;
use ieee.std_logic_1164.all;
use work.skinnypkg.all;

entity f2 is

port (a0, a1, a3 : in std_logic;
      b0, b1, b3 : in std_logic;
      c0, c1, c3 : in std_logic;
      d0, d1, d3 : in std_logic;
      e0, e1, e3 : in std_logic;
      f0, f1, f3 : in std_logic;
      g0, g1, g3 : in std_logic;
      h0, h1, h3 : in std_logic;

      y0, y1, y2, y3, y4, y5, y6, y7, y8 : out std_logic);

end entity f2;

architecture word of f2 is begin
y0 <= (e3) xor (g0 and h1) xor (g1 and h0) xor (g3 and h0) xor (g3 and h1) xor (g3 and h3) xor (g3) xor (h3);
y1 <= (a3) xor (c0 and d1) xor (c1 and d0) xor (c3 and d0) xor (c3 and d1) xor (c3 and d3) xor (c3) xor (d3);
y2 <= (a0 and d1) xor (a1 and d0) xor (a3 and d0) xor (a3 and d1) xor (a3 and d3) xor (a3) xor (b3) xor (c1 and d0) xor (c3 and d0) xor (c3 and d1) xor (c3 and d3) xor (c3);
y3 <= (b0 and c1) xor (b1 and c0) xor (b3 and c0) xor (b3 and c1) xor (b3 and c3) xor (b3) xor (c3) xor (g3);
y4 <= (h1) xor (e1) xor (a0 and b1) xor (a1 and b0) xor (a3 and b0) xor (a3 and b1) xor (b0 and c0 and d1) xor (b0 and c1 and d0) xor (b0 and c1 and d3) xor (b0 and c1) xor (b0 and c3 and d0) xor (b0 and c3 and d1) xor (b0 and c3) xor (b0 and d3) xor (b1 and c0 and d1) xor (b1 and c0 and d3) xor (b1 and c1 and d0) xor (b1 and c3 and d0) xor (b1 and d1) xor (b3 and c0 and d0) xor (b3 and c0 and d1) xor (b3 and c0 and d3) xor (b3 and c0) xor (b3 and c1 and d0) xor (b3 and c1 and d1) xor (b3 and c1 and d3) xor (b3 and c1) xor (b3 and c3 and d0) xor (b3 and c3 and d1) xor (b3 and c3 and d3) xor (b3 and d0) xor (b3 and d3) xor (b3);
y5 <= (c3);
y6 <= (d3);
y7 <= (f3);
y8 <= (h3);

end architecture word;

