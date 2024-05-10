library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity REGISTER_FILE is
    port (
        clk : in std_logic;
		  reset : in std_logic;
        reg_write_enable : in std_logic;
        write_address : in std_logic_vector(2 downto 0);
        write_data : in std_logic_vector(15 downto 0);
		  write_pc : in std_logic_vector(15 downto 0);
        read_address1 	: in std_logic_vector(2 downto 0);
        read_address2 : in std_logic_vector(2 downto 0);
		  read_pc : out std_logic_vector(15 downto 0);
        data_out1 : out std_logic_vector(15 downto 0);
        data_out2 : out std_logic_vector(15 downto 0);
		  alu_write_enable : in std_logic;
		  alu_write_address : in std_logic_vector(2 downto 0);
		  alu_write_data : in std_logic_vector(15 downto 0)
    );
end REGISTER_FILE;

architecture Behavioral of REGISTER_FILE is
    type reg_array is array (0 to 7) of std_logic_vector(15 downto 0);
    signal registers : reg_array := (
        "0000000000000000", -- 	(0)
        "0000000000000001", -- 	(1)
        "0000000000000010", -- 	(2)
        "0000000000000011", -- 	(3)
        "0000000000000100", -- 	(4)
        "0000000000000101", -- 	(5)
        "0000000000000110", -- 	(6)
        "0000000000000111"  -- 	(7)
    );

begin
    process (clk)
        variable temp : reg_array; -- Declare a variable to hold temporary values
    begin
			 if reset = '1' then
            -- Assign initial values to temp_	 during reset
            temp	 := (
                "0000000000000000", -- 	(0)
                "0000000000000001", -- 	(1)
                "0000000000000010", -- 	(2)
                "0000000000000011", -- 	(3)
                "0000000000000100", -- 	(4)
                "0000000000000101", -- 	(5)
                "0000000000000110", -- 	(6)
                "0000000000000111"  -- 	(7)
            );
				registers <= temp;
			 elsif rising_edge(clk) then
			 
					if alu_write_address = "000" and write_address = "000" then
						if alu_write_enable = '1' then 
							registers(0) <= alu_write_data;
						elsif reg_write_enable = '1' then 
							registers(0) <= write_data;
						else 
							registers(0) <= write_pc;
						end if;	
								
					elsif to_integer(unsigned(alu_write_address)) - to_integer(unsigned(write_address)) = 0  then
						if alu_write_enable = '1' then 
							registers(to_integer(unsigned(alu_write_address))) <= alu_write_data;
							registers(0) <= write_pc;
						end if;
					
					else 
						if alu_write_address = "000" and alu_write_enable = '1' then 
							registers(0) <= alu_write_data;
							if reg_write_enable = '1' then
								registers(to_integer(unsigned(write_address))) <= write_data;
							end if;
						elsif write_address = "000" and reg_write_enable = '1' then 
							registers(0) <= write_data;
							if alu_write_enable = '1' then
								registers(to_integer(unsigned(alu_write_address))) <= alu_write_data;
							end if;
						else 
							if reg_write_enable = '1' then
								registers(to_integer(unsigned(write_address))) <= write_data;
							end if;
							if alu_write_enable = '1' then						
								registers(to_integer(unsigned(alu_write_address))) <= alu_write_data;
							end if;
							registers(0) <= write_pc;
						end if;
					end if;	
					
			end if;		
		  
    end process;
    
    data_out1 <= 	registers(to_integer(unsigned(read_address1)));
    data_out2 <= 	registers(to_integer(unsigned(read_address2)));
    read_pc   <= 	registers(0);
     
end Behavioral;