library ieee;
use ieee.std_logic_1164.all;

entity reg is
	generic (n : integer);
	port (clk : in 	std_logic;
          
          reset_n   : in std_logic;
          load_init : in std_logic;
          load_upd  : in std_logic;

          d_init : in std_logic_vector((n - 1) downto 0);
          d_upd  : in std_logic_vector((n - 1) downto 0);
          q      : out std_logic_vector((n - 1) downto 0)
    );
end reg;

architecture behavioural of reg is
begin

    bank : process(clk)
    begin
        if rising_edge(clk) then
            if reset_n = '0' then
                q <= (others => '0');
            elsif load_init = '1' then
                q <= d_init;
            elsif load_upd = '1' then
                q <= d_upd;
            end if;
        end if;
    end process;

end architecture behavioural;
