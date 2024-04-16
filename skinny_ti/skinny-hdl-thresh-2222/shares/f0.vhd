
library ieee;
use ieee.std_logic_1164.all;
use work.skinnypkg.all;

entity f0 is

port (a1, a2 : in std_logic;
      b1, b2 : in std_logic;
      c1, c2 : in std_logic;
      d1, d2 : in std_logic;
      e1, e2 : in std_logic;
      f1, f2 : in std_logic;
      g1, g2 : in std_logic;
      h1, h2 : in std_logic;

      y0, y1, y2, y3, y4, y5, y6, y7 : out std_logic);

end entity f0;

architecture word of f0 is begin
y0 <= (e1) xor (e2) xor (g1 and h1) xor (g1 and h2) xor (g2 and h1) xor (h1) xor (h2) xor ('1');
y1 <= (a1) xor (a2) xor (c1 and d1) xor (c1 and d2) xor (c2 and d1) xor (d1) xor (d2) xor ('1');
y2 <= (b2);
y3 <= (c2);
y4 <= (d2);
y5 <= (f2);
y6 <= (g2);
y7 <= (h2);

end architecture word;

