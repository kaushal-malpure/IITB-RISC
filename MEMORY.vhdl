library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Memory is
    port (
        clk : in std_logic;
        address : in std_logic_vector(15 downto 0);
        data_in : in std_logic_vector(15 downto 0);
        write_enable : in std_logic;
        data_out : out std_logic_vector(15 downto 0)
    );
end Memory;

architecture Behavioral of Memory is
    type memory_array is array (0 to 65535) of std_logic_vector(15 downto 0);
	     SIGNAL Memory_Data : memory_array := (
      0  => "0000000000000000",
		1  => "0000000000000000",
		2  => "0000000000000000",
		3  => "0000000000000000",
		4  => "0000000000000000",
		5  => "0000000000000000",
		6  => "0000000000000000",
		7  => "0000000000000000",
		8  => "0000000000000000",
--		9  => "1000001000000000",
--		10 => "1001000000000001",
--		11 => "1010001000000000",
--		12 => "1101000001000000",
--		13 => "0110000001111000",
--		14 => "1010001010000000",
--		15 => "0110000001010000",
--		16 => "0001000001000010",
--		17 => "1000000000000010",
--		18 => "1001000000000010",
--		19 => "1010000001000010",
--		20 => "1011000001000010",
--		21 => "1100000001000010",
--		22 => "1101000000000001",
--		23 => "1111000001000000",
		41024 => "0000000000000000",
		
		OTHERS => "0000000000000000");

begin
    process (clk)
    begin
        if rising_edge(clk) then
            if write_enable = '1' then
                Memory_Data(to_integer(unsigned(address))) <= data_in;
            else
            data_out <= Memory_Data(to_integer(unsigned(address)));
				end if;
				
        end if;
    end process;
end Behavioral;