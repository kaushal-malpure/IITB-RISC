library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.ALL;

entity pipeline_4 is
	port (input:in std_logic_vector(81 downto 0);
			reset : in std_logic;	
			w_enable, clk: in std_logic;
			output: out std_logic_vector(81 downto 0));
end pipeline_4;

architecture Behavioral of pipeline_4 is
    signal p4 : std_logic_vector(81 downto 0) := (others => '0');     -- [,Rega(81-66),Regb(65-50),zflag(49),cflag(48)Regc(47-32),IR(31-16),pc(15-0)]
begin
    process(clk, reset)
    begin
        if reset = '1' then
            p4 <= (others => '0');
        elsif rising_edge(clk) then
            if w_enable = '1' then
                p4 <= input;
            end if;
        end if;
    end process;

    output <= p4;
end Behavioral;
