
library ieee;
use ieee.std_logic_1164.all;
use work.skinnypkg.all;

entity g2 is

port (a0, a1, a3 : in std_logic;
      b0, b1, b3 : in std_logic;
      c0, c1, c3 : in std_logic;
      d0, d1, d3 : in std_logic;
      e0, e1, e3 : in std_logic;
      f0, f1, f3 : in std_logic;
      g0, g1, g3 : in std_logic;
      h0, h1, h3 : in std_logic;
      i0, i1, i3 : in std_logic;

      y0, y1, y2, y3, y4, y5, y6, y7 : out std_logic);

end entity g2;

architecture word of g2 is begin
y0 <= (a0 and b0 and d1) xor (a0 and b0) xor (a0 and b1 and d1) xor (a0 and b1 and d3) xor (a0 and b3 and d0) xor (a0 and b3 and d1) xor (a0 and b3 and d3) xor (a0 and c0 and d3) xor (a0 and c1 and d0) xor (a0 and c1 and d3) xor (a0 and c1) xor (a0 and c3 and d0) xor (a0 and c3 and d1) xor (a0 and c3) xor (a0 and d0 and e3) xor (a0 and d1 and e0) xor (a0 and d1 and e3) xor (a0 and d1) xor (a0 and d3 and e0) xor (a0 and d3 and e1) xor (a0 and d3) xor (a1 and b0 and d0) xor (a1 and b0 and d3) xor (a1 and b0) xor (a1 and b3 and d0) xor (a1 and c0 and d0) xor (a1 and c0 and d3) xor (a1 and c0) xor (a1 and c3 and d0) xor (a1 and d0 and e0) xor (a1 and d0 and e3) xor (a1 and d0) xor (a1 and d3 and e0) xor (a1 and d3 and e3) xor (a1 and e1) xor (a3 and b0 and d0) xor (a3 and b0 and d1) xor (a3 and b0 and d3) xor (a3 and b0) xor (a3 and b1 and d0) xor (a3 and b1 and d1) xor (a3 and b1 and d3) xor (a3 and b1) xor (a3 and b3 and d0) xor (a3 and b3 and d1) xor (a3 and b3 and d3) xor (a3 and b3) xor (a3 and c0 and d0) xor (a3 and c0 and d1) xor (a3 and c0 and d3) xor (a3 and c0) xor (a3 and c1 and d0) xor (a3 and c1 and d1) xor (a3 and c1 and d3) xor (a3 and c1) xor (a3 and c3 and d0) xor (a3 and c3 and d1) xor (a3 and c3 and d3) xor (a3 and c3) xor (a3 and d0 and e0) xor (a3 and d0 and e1) xor (a3 and d0 and e3) xor (a3 and d1 and e0) xor (a3 and d1 and e3) xor (a3 and d3 and e0) xor (a3 and d3 and e1) xor (a3 and d3 and e3) xor (a3 and e1) xor (a3) xor (b0 and d3) xor (b3 and c0) xor (b3 and c1) xor (b3 and c3) xor (b3 and d3) xor (b3) xor (c0 and d1 and h1) xor (c0 and d1 and h3) xor (c0 and d3 and h0) xor (c0 and d3 and h1) xor (c0 and d3 and h3) xor (c0 and i0) xor (c0 and i3) xor (c1 and d0 and h1) xor (c1 and d0 and h3) xor (c1 and d3 and h0) xor (c1 and h0) xor (c1 and i1) xor (c3 and d0 and h0) xor (c3 and d0 and h1) xor (c3 and d0 and h3) xor (c3 and d1 and h0) xor (c3 and d1 and h1) xor (c3 and d1 and h3) xor (c3 and d3 and h0) xor (c3 and d3 and h1) xor (c3 and d3 and h3) xor (c3 and h0) xor (c3 and h1) xor (c3 and i0) xor (c3 and i3) xor (c3) xor (d1 and e0) xor (d1 and h1) xor (d3 and e0) xor (d3 and e1) xor (d3 and e3) xor (d3 and h1) xor (f3) xor (h3) xor (i3);
y1 <= (a0 and b0 and d1) xor (a0 and b0) xor (a0 and b1 and d1) xor (a0 and b1 and d3) xor (a0 and b3 and d0) xor (a0 and b3 and d1) xor (a0 and b3 and d3) xor (a0 and d3) xor (a1 and b0 and d0) xor (a1 and b0 and d3) xor (a1 and b0) xor (a1 and b3 and d0) xor (a1 and d0) xor (a3 and b0 and d0) xor (a3 and b0 and d1) xor (a3 and b0 and d3) xor (a3 and b0) xor (a3 and b1 and d0) xor (a3 and b1 and d1) xor (a3 and b1 and d3) xor (a3 and b1) xor (a3 and b3 and d0) xor (a3 and b3 and d1) xor (a3 and b3 and d3) xor (a3 and d0) xor (a3 and d3) xor (a3) xor (b3 and d0) xor (b3 and d1) xor (b3 and d3) xor (b3) xor (d1 and h0) xor (d3 and h0) xor (d3 and h1) xor (h3) xor (i3);
y2 <= (d3);
y3 <= (c3);
y4 <= (a0 and b1) xor (a0 and h0) xor (a0 and h3) xor (a1 and h0) xor (a3 and b0) xor (a3 and b1) xor (a3 and b3) xor (a3 and h1) xor (b3) xor (g3) xor (h3);
y5 <= (b3);
y6 <= (a3);
y7 <= (a0 and b1) xor (a1 and b0) xor (a3 and b0) xor (a3 and b1) xor (a3 and b3) xor (a3) xor (b3) xor (h3);

end architecture word;

