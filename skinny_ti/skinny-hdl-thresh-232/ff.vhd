library ieee;
use ieee.std_logic_1164.all;

entity ff is
	port (clk   : in  std_logic;
          d     : in  std_logic;
          q     : out std_logic);
end ff;

architecture behavioural of ff is
begin
    
    reg : process(clk)
    begin
        if rising_edge(clk) then
            q <= d;
        end if;
    end process;

end behavioural;
