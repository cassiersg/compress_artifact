
library ieee;
use ieee.std_logic_1164.all;
use work.skinnypkg.all;

entity g1 is

port (a0, a2, a3 : in std_logic;
      b0, b2, b3 : in std_logic;
      c0, c2, c3 : in std_logic;
      d0, d2, d3 : in std_logic;
      e0, e2, e3 : in std_logic;
      f0, f2, f3 : in std_logic;
      g0, g2, g3 : in std_logic;
      h0, h2, h3 : in std_logic;
      i0, i2, i3 : in std_logic;

      y0, y1, y2, y3, y4, y5, y6, y7 : out std_logic);

end entity g1;

architecture word of g1 is begin
y0 <= (a0 and b0 and d0) xor (a0 and b0 and d3) xor (a0 and b2 and d0) xor (a0 and b2 and d2) xor (a0 and b2 and d3) xor (a0 and b2) xor (a0 and b3 and d2) xor (a0 and b3) xor (a0 and c0) xor (a0 and c2 and d0) xor (a0 and c2 and d2) xor (a0 and c2 and d3) xor (a0 and c3 and d2) xor (a0 and c3 and d3) xor (a0 and d0 and e2) xor (a0 and d2 and e0) xor (a0 and d2 and e2) xor (a0 and d2 and e3) xor (a0 and d2) xor (a0 and d3 and e2) xor (a0 and d3 and e3) xor (a0 and e3) xor (a0) xor (a2 and b0 and d0) xor (a2 and b0 and d2) xor (a2 and b0 and d3) xor (a2 and b0) xor (a2 and b2 and d0) xor (a2 and b2 and d2) xor (a2 and b2 and d3) xor (a2 and b2) xor (a2 and b3 and d0) xor (a2 and b3 and d2) xor (a2 and b3 and d3) xor (a2 and b3) xor (a2 and c0 and d0) xor (a2 and c0 and d2) xor (a2 and c0 and d3) xor (a2 and c0) xor (a2 and c2 and d0) xor (a2 and c2 and d2) xor (a2 and c2 and d3) xor (a2 and c2) xor (a2 and c3 and d0) xor (a2 and c3 and d2) xor (a2 and c3) xor (a2 and d0 and e3) xor (a2 and d2 and e0) xor (a2 and d2 and e2) xor (a2 and d2 and e3) xor (a2 and d3 and e0) xor (a2 and d3 and e3) xor (a2 and e2) xor (a3 and b0 and d2) xor (a3 and b2 and d0) xor (a3 and b2 and d2) xor (a3 and b2) xor (a3 and c0 and d2) xor (a3 and c2 and d0) xor (a3 and c2 and d2) xor (a3 and c2) xor (a3 and d0 and e2) xor (a3 and d0) xor (a3 and d2 and e0) xor (a3 and d2 and e2) xor (a3 and d2 and e3) xor (a3 and d3 and e2) xor (a3 and e0) xor (a3 and e3) xor (b0 and c3) xor (b0) xor (b2 and c3) xor (b3 and c2) xor (b3 and d0) xor (c0 and d0 and h2) xor (c0 and d0 and h3) xor (c0 and d2 and h0) xor (c0 and d2 and h2) xor (c0 and d2 and h3) xor (c0 and d3 and h2) xor (c0 and h3) xor (c0 and i2) xor (c0) xor (c2 and d0 and h0) xor (c2 and d0 and h2) xor (c2 and d0 and h3) xor (c2 and d2 and h0) xor (c2 and d2 and h2) xor (c2 and d2 and h3) xor (c2 and d3 and h0) xor (c2 and d3 and h2) xor (c2 and d3 and h3) xor (c2 and h2) xor (c2 and i2) xor (c3 and d0 and h2) xor (c3 and d2 and h0) xor (c3 and d2 and h2) xor (c3 and d3 and h2) xor (c3 and h3) xor (c3 and i2) xor (d0 and e3) xor (d0 and h3) xor (d2 and e0) xor (d2 and e2) xor (d2 and h0) xor (d2 and h3) xor (d3 and h0) xor (d3 and h3) xor (f0) xor (h0) xor (i0);
y1 <= (a0 and b0 and d0) xor (a0 and b0 and d3) xor (a0 and b2 and d0) xor (a0 and b2 and d2) xor (a0 and b2 and d3) xor (a0 and b2) xor (a0 and b3 and d2) xor (a0 and b3) xor (a0) xor (a2 and b0 and d0) xor (a2 and b0 and d2) xor (a2 and b0 and d3) xor (a2 and b0) xor (a2 and b2 and d0) xor (a2 and b2 and d2) xor (a2 and b2 and d3) xor (a2 and b2) xor (a2 and b3 and d0) xor (a2 and b3 and d2) xor (a2 and b3) xor (a3 and b0 and d2) xor (a3 and b2 and d0) xor (a3 and b2 and d2) xor (a3 and b2) xor (a3 and b3) xor (a3 and d2) xor (b0 and d3) xor (b0) xor (b2 and d2) xor (b3 and d2) xor (d0 and h2) xor (d0 and h3) xor (d2 and h2) xor (d3 and h2) xor (h0) xor (i0);
y2 <= (d0);
y3 <= (c0);
y4 <= (a0 and b0) xor (a0 and b3) xor (a0 and h2) xor (a2 and b0) xor (a2 and b2) xor (a2 and h0) xor (a2 and h3) xor (a3 and h0) xor (a3 and h3) xor (b0) xor (g0) xor (h0);
y5 <= (b0);
y6 <= (a0);
y7 <= (a0 and b0) xor (a0 and b3) xor (a0) xor (a2 and b2) xor (a3 and b2) xor (b0) xor (h0);

end architecture word;

