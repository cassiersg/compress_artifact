
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

      y0, y1, y2, y3, y4, y5, y6, y7 : out std_logic);

end entity g2;

architecture word of g2 is begin
y0 <= (a0 and b1) xor (a1 and b0) xor (a3 and b0) xor (a3 and b1) xor (a3 and b3) xor (a3) xor (b3) xor (g3);
y1 <= (a3);
y2 <= (b3);
y3 <= (c3);
y4 <= (d3);
y5 <= (a0 and b0 and d1) xor (a0 and b0) xor (a0 and b1 and d1) xor (a0 and b1 and d3) xor (a0 and b3 and d0) xor (a0 and b3 and d1) xor (a0 and b3 and d3) xor (a0 and d3) xor (a1 and b0 and d0) xor (a1 and b0 and d3) xor (a1 and b0) xor (a1 and b3 and d0) xor (a1 and d0) xor (a3 and b0 and d0) xor (a3 and b0 and d1) xor (a3 and b0 and d3) xor (a3 and b0) xor (a3 and b1 and d0) xor (a3 and b1 and d1) xor (a3 and b1 and d3) xor (a3 and b1) xor (a3 and b3 and d0) xor (a3 and b3 and d1) xor (a3 and b3 and d3) xor (a3 and d0) xor (a3 and d3) xor (a3) xor (b3 and d0) xor (b3 and d1) xor (b3 and d3) xor (b3) xor (d1 and g0) xor (d3 and g0) xor (d3 and g1) xor (g3) xor (h3);
y6 <= (e3);
y7 <= (f3);

end architecture word;

