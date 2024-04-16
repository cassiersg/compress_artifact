
library ieee;
use ieee.std_logic_1164.all;
use work.skinnypkg.all;

entity f3 is

port (a0 : in std_logic;
      b0 : in std_logic;
      c0 : in std_logic;
      d0 : in std_logic;
      e0 : in std_logic;
      f0 : in std_logic;
      g0 : in std_logic;
      h0 : in std_logic;

      y0, y1, y2, y3, y4, y5, y6, y7 : out std_logic);

end entity f3;

architecture word of f3 is begin
y0 <= (h0);
y1 <= (d0);
y2 <= (c0 and d0) xor (c0);
y3 <= (g0);
y4 <= (a0);
y5 <= (a0);
y6 <= (a0);
y7 <= (a0);

end architecture word;

