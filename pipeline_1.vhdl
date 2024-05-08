library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.ALL;

entity pipeline_1 is
	port (input:in std_logic_vector(31 downto 0);
			reset : in std_logic;
			w_enable, clk: in std_logic;
			output: out std_logic_vector(31 downto 0));
end pipeline_1;

architecture Behavioral of pipeline_1 is
    signal p1 : std_logic_vector(31 downto 0) := (others => '0');     -- [IR(31-16),IP(15-0)]
	 begin
			 process(clk, reset)
				 begin
					  if reset = '1' then
							p1 <= (others => '0');
					  elsif rising_edge(clk) then
							if w_enable = '1' then
								 p1 <= input;
							end if;
					  end if;
    end process;

    output <= p1;
end Behavioral;
