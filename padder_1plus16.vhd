library ieee;
use ieee.std_logic_1164.all;

entity Padder1plus16 is
    port (
        input_bit : in std_logic_vector(15 downto 0);
        output_vector : out std_logic_vector(16 downto 0)
    );
end entity Padder1plus16;

architecture Behavioral of Padder1plus16 is
begin
    process (input_bit)
    begin
        -- Concatenate 15 bits of '0' with input_bit to form a 16-bit vector
        output_vector <= (others => '0') & input_bit;
    end process;
end architecture Behavioral;
