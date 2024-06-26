library ieee;
use ieee.std_logic_1164.all;

entity Padder16plus1 is
    port (
        input_bit : in std_logic;
        output_vector : out std_logic_vector(16 downto 0)
    );
end entity Padder16plus1;

architecture Behavioral of Padder16plus1 is
begin
    process (input_bit)
    begin
        -- Concatenate 15 bits of '0' with input_bit to form a 16-bit vector
        output_vector <= "0000000000000000" & input_bit;
    end process;
end architecture Behavioral;
