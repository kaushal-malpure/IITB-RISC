library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.ALL;

entity pipeline_5 is
	port (input:in std_logic_vector(47 downto 0);
			reset : in std_logic;
			w_enable, clk: in std_logic;
			output: out std_logic_vector(47 downto 0));
end pipeline_5;

architecture Behavioral of pipeline_4 is
    signal p5 : std_logic_vector(47 downto 0) := (others => '0');     -- [Regc(47-32),IR(31-16),IP(15-0)]
begin
    process(clk, reset)
    begin
        if reset = '1' then
            p5 <= (others => '0');
        elsif rising_edge(clk) then
            if w_enable = '1' then
                p5 <= input;
            end if;
        end if;
    end process;

    output <= p5;
end Behavioral;
