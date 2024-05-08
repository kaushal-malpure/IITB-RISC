library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Complementer is
    port (
        input_vector : in std_logic_vector(15 downto 0);
        complemented_vector : out std_logic_vector(15 downto 0)
    );
end entity Complementer;

architecture Behavioral of Complementer is
begin
    process (input_vector)
    begin
        for i in input_vector'range loop
            complemented_vector(i) <= not input_vector(i);
        end loop;
    end process;
end architecture Behavioral;
