library ieee;
use ieee.std_logic_1164.all;

entity sff is
	port (clk   : in  std_logic;
          sel   : in  std_logic;
          d     : in  std_logic;
          ds    : in  std_logic;
          q     : out std_logic);
end sff;

architecture behavioural of sff is
begin
    
    reg : process(clk, sel)
    begin
        if rising_edge(clk) then
            if sel = '1' then
                q <= ds;
            else
                q <= d;
            end if;
        end if;
    end process;

end behavioural;
