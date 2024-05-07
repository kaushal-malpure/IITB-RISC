library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity LeftShifter is
    Port ( input : in std_logic_vector(15 downto 0);
           output : out std_logic_vector(15 downto 0)
    );
end LeftShifter;

architecture Behavioral of LeftShifter is
begin
    process(input)
    begin
        -- Shift the input to the left by 1 bit
        output <= input(14 downto 0) & '0';
    end process;
end Behavioral;