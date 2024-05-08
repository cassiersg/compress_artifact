library ieee;
use ieee.std_logic_1164.all;

use work.skinnypkg.all;

entity h is
	port (x0, x1, x2, x3 : in  std_logic_vector(7 downto 0);
          y0, y1, y2     : out std_logic_vector(7 downto 0));
end h;

architecture structural of h is
 
    signal w0, w1, w2 : std_logic_vector(7 downto 0);

begin

	h0 : entity work.h0 port map (
        x1(0), x2(0), x3(0),
        x1(1), x2(1), x3(1),
        x1(2), x2(2), x3(2),
        x1(3), x2(3), x3(3),
        x1(4), x2(4), x3(4),
        x1(5), x2(5), x3(5),
        x1(6), x2(6), x3(6),
        x1(7), x2(7), x3(7),

        w0(0), w0(1), w0(2), w0(3), w0(4), w0(5), w0(6), w0(7)
    );
	
    h1 : entity work.h1 port map (
        x0(0), x3(0),
        x0(1), x3(1),
        x0(2), x3(2),
        x0(3), x3(3),
        x0(4), x3(4),
        x0(5), x3(5),
        x0(6), x3(6),
        x0(7), x3(7),

        w1(0), w1(1), w1(2), w1(3), w1(4), w1(5), w1(6), w1(7)
    );
    
    h2 : entity work.h2 port map (
        x0(0), x1(0), x2(0),
        x0(1), x1(1), x2(1),
        x0(2), x1(2), x2(2),
        x0(3), x1(3), x2(3),
        x0(4), x1(4), x2(4),
        x0(5), x1(5), x2(5),
        x0(6), x1(6), x2(6),
        x0(7), x1(7), x2(7),

        w2(0), w2(1), w2(2), w2(3), w2(4), w2(5), w2(6), w2(7)
    );
    
    y0 <= w0;
    y1 <= w1;
    y2 <= w2;

end structural;

