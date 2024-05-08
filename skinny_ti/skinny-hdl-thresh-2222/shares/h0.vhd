
library ieee;
use ieee.std_logic_1164.all;
use work.skinnypkg.all;

entity h0 is

port (a1, a2 : in std_logic;
      b1, b2 : in std_logic;
      c1, c2 : in std_logic;
      d1, d2 : in std_logic;
      e1, e2 : in std_logic;
      f1, f2 : in std_logic;
      g1, g2 : in std_logic;
      h1, h2 : in std_logic;

      y0, y1, y2, y3, y4, y5, y6, y7 : out std_logic);

end entity h0;

architecture word of h0 is begin
y0 <= (a2);
y1 <= (b2);
y2 <= (c2);
y3 <= (c1 and g1) xor (c1 and g2) xor (c1) xor (c2 and g1) xor (c2 and g2) xor (c2) xor (g1) xor (g2) xor ('1');
y4 <= (d2);
y5 <= (a1 and d1) xor (a1 and d2) xor (a1) xor (a2 and d1) xor (a2 and d2) xor (a2) xor (h1) xor (h2) xor ('1');
y6 <= (f2);
y7 <= (g2);

end architecture word;

