library ieee;
use ieee.std_logic_1164.all;

entity sffe is
	port (clk   : in  std_logic;
          sel   : in  std_logic;
          en    : in  std_logic;
          d     : in  std_logic;
          ds    : in  std_logic;
          q     : out std_logic);
end sffe;

architecture behavioural of sffe is
begin
    
    reg : process(clk, sel, en)
    begin
        if rising_edge(clk) then
            if sel = '1' then
                q <= ds;
            elsif (en = '1') then
                q <= d;
            end if;
        end if;
    end process;

end behavioural;
