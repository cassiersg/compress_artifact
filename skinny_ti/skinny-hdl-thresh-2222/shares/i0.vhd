
library ieee;
use ieee.std_logic_1164.all;
use work.skinnypkg.all;

entity i0 is

port (a1, a2 : in std_logic;
      b1, b2 : in std_logic;
      c1, c2 : in std_logic;
      d1, d2 : in std_logic;
      e1, e2 : in std_logic;
      f1, f2 : in std_logic;
      g1, g2 : in std_logic;
      h1, h2 : in std_logic;

      y0, y1, y2, y3, y4, y5, y6, y7 : out std_logic);

end entity i0;

architecture word of i0 is begin
y0 <= (d1 and f1) xor (d1 and f2) xor (d1) xor (d2 and f1) xor (d2 and f2) xor (d2) xor (g1) xor (g2) xor ('1');
y1 <= (f2);
y2 <= (e2);
y3 <= (d2);
y4 <= (a1 and b1) xor (a1 and b2) xor (a1) xor (a2 and b1) xor (a2 and b2) xor (a2) xor (h1) xor (h2) xor ('1');
y5 <= (c2);
y6 <= (b2);
y7 <= (a2);

end architecture word;

