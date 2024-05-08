
library ieee;
use ieee.std_logic_1164.all;
use work.skinnypkg.all;

entity g2 is

port (a0, a1 : in std_logic;
      b0, b1 : in std_logic;
      c0, c1 : in std_logic;
      d0, d1 : in std_logic;
      e0, e1 : in std_logic;
      f0, f1 : in std_logic;
      g0, g1 : in std_logic;
      h0, h1 : in std_logic;

      y0, y1, y2, y3, y4, y5, y6, y7 : out std_logic);

end entity g2;

architecture word of g2 is begin
y0 <= (a0 and b1) xor (a1 and b0) xor (b0) xor (b1);
y1 <= (a1);
y2 <= (b1);
y3 <= (c0 and d1) xor (c1 and d0) xor (d0) xor (d1);
y4 <= (c1);
y5 <= (d1);
y6 <= (e1);
y7 <= (h1);

end architecture word;

