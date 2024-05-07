library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Register_File is
    port (
        clk : in std_logic;
		  reset : in std_logic;
        reg_write_enable : in std_logic;
        write_address : in std_logic_vector(2 downto 0);
        write_data : in std_logic_vector(15 downto 0);
		  write_pc : in std_logic_vector(15 downto 0);
        read_address1 : in std_logic_vector(2 downto 0);
        read_address2 : in std_logic_vector(2 downto 0);
		  read_pc : out std_logic_vector(15 downto 0);
        data_out1 : out std_logic_vector(15 downto 0);
        data_out2 : out std_logic_vector(15 downto 0)
    );
end Register_File;

architecture Behavioral of Register_File is
    type reg_array is array (0 to 7) of std_logic_vector(15 downto 0);
    signal registers : reg_array := (
        "0000000000000000", -- registers(0)
        "0000000000000001", -- registers(1)
        "0000000000000010", -- registers(2)
        "0000000000000011", -- registers(3)
        "0000000000000100", -- registers(4)
        "0000000000000101", -- registers(5)
        "0000000000000110", -- registers(6)
        "0000000000000111"  -- registers(7)
    );

begin
    process (clk)
        variable temp_registers : reg_array; -- Declare a variable to hold temporary values
    begin
        if reset = '1' then
            -- Assign initial values to temp_registers during reset
            temp_registers := (
                "0000000000000000", -- registers(0)
                "0000000000000001", -- registers(1)
                "0000000000000010", -- registers(2)
                "0000000000000011", -- registers(3)
                "0000000000000100", -- registers(4)
                "0000000000000101", -- registers(5)
                "0000000000000110", -- registers(6)
                "0000000000000111"  -- registers(7)
            );
        elsif rising_edge(clk) then
            if write_address = "000" and reg_write_enable = '1' then
                registers(to_integer(unsigned(write_address))) <= write_data;
            else
                registers(0) <= write_pc;  
            end if;
        end if;
    end process;
    
    data_out1 <= registers(to_integer(unsigned(read_address1)));
    data_out2 <= registers(to_integer(unsigned(read_address2)));
    read_pc   <= registers(0);
     
end Behavioral;
