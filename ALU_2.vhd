library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU_2 is
    Port ( A : in  std_logic_vector(15 downto 0);
           result : out  std_logic_vector(15 downto 0)
			  );
end ALU_2;

architecture Behavioral of ALU_2 is
signal sg : std_logic_vector(15 downto 0) := "0000000000000010";
begin

    process (A)
	     variable temp_int : integer;
        variable temp : std_logic_vector(15 downto 0);
    begin
        temp_int := to_integer(unsigned(A)) + to_integer(unsigned(sg))  ; -- Add 2 to A
		  temp := std_logic_vector(to_unsigned(temp_int,16));
        result <= temp(15 downto 0);
        
    end process;

end Behavioral;