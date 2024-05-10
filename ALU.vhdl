library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is 
    port (
        IR : in std_logic_vector(15 downto 0);  
        REGA : in std_logic_vector(15 downto 0);
        REGB : in std_logic_vector(15 downto 0);	
		  PIPE4 : in std_logic_vector(49 downto 0);
        OUTPUT : out std_logic_vector(15 downto 0);
        Zout : out std_logic;
        Cout : out std_logic
    );
end ALU;

architecture Behavioral of ALU is

    signal temp_int : integer;	
	 signal temp : std_logic_vector(16 downto 0);
	 signal comp_regb_16 : std_logic_vector(15 downto 0);
    signal rega_extended, rega_extended_new, regb_extended, regb_extended_new, tempc_extended, tempz_extended, comp_regb, regc_extended : std_logic_vector(16 downto 0);
    signal se_imm_padd : std_logic_vector(16 downto 0);
    signal se_imm_padd_16 : std_logic_vector(15 downto 0);

	 
    component Padder1plus16 is
        port (
            input_bit : in std_logic_vector(15 downto 0);
            output_vector : out std_logic_vector(16 downto 0)
        );
    end component Padder1plus16;
     
    component Padder16plus1 is
        port (
            input_bit : in std_logic;
            output_vector : out std_logic_vector(16 downto 0)
        );
    end component Padder16plus1;
    
    component Complementer is
        port (
            input_vector : in std_logic_vector(15 downto 0);
            complemented_vector : out std_logic_vector(15 downto 0)
        );
    end component Complementer;
    
    component sign_extender_10plus6 is
        port(
            inp_6bit : in std_logic_vector(5 downto 0);
            outp_16bit : out std_logic_vector(15 downto 0)
        ); 
    end component sign_extender_10plus6;
    
begin

    extend1 : Padder1plus16 port map(REGA, rega_extended_new);
    extend2 : Padder1plus16 port map(REGB, regb_extended_new);
    extend3 : Padder16plus1 port map(pipe4(48), tempc_extended);
    extend4 : Padder16plus1 port map(pipe4(49), tempz_extended);
	 extend5 : padder1plus16 port map(pipe4(47 downto 32), regc_extended); 
    comp1 : Complementer port map(REGB, comp_regb_16);
	 extend6 : padder1plus16 port map(comp_regb_16, comp_regb);
    signExtend1 : sign_extender_10plus6 port map(IR(5 downto 0), se_imm_padd_16);
	 extend7 : padder1plus16 port map(se_imm_padd_16, se_imm_padd);
    
    process (IR, REGA, REGB ,PIPE4, rega_extended, regb_extended, comp_regb, tempc_extended, regc_extended, tempz_extended, se_imm_padd, rega_extended_new, regb_extended_new , temp, temp_int)
    begin
			
			rega_extended <= rega_extended_new;
			regb_extended <= regb_extended_new;
			
			if to_integer(unsigned(IR(11 downto 9))) - to_integer(unsigned(pipe4(21 downto 19))) = 0 then
				 rega_extended <= regc_extended;
			elsif to_integer(unsigned(IR(8 downto 6))) - to_integer(unsigned(pipe4(21 downto 19))) = 0 then
				 regb_extended <= regc_extended;
			end if;
			
			case IR(15 downto 12) is
				when "0001" =>   -- 8 cases for add
					 if IR(2) = '0' then
						  if IR(1 downto 0) = "00" then
								temp_int <= to_integer(unsigned(rega_extended)) + to_integer(unsigned(regb_extended));
						  elsif IR(1 downto 0) = "01" then
								if pipe4(49) = '1' then
									 temp_int <= to_integer(unsigned(rega_extended)) + to_integer(unsigned(regb_extended));
								end if;
						  elsif IR(1 downto 0) = "10" then
								if pipe4(48) = '1' then
									 temp_int <= to_integer(unsigned(rega_extended)) + to_integer(unsigned(regb_extended));
								end if;
						  elsif IR(1 downto 0) = "11" then
								temp_int <= to_integer(unsigned(rega_extended)) + to_integer(unsigned(regb_extended)) + to_integer(unsigned(tempc_extended));
						  end if;
					 elsif IR(2) = '1' then
						  if IR(1 downto 0) = "00" then
								temp_int <= to_integer(unsigned(rega_extended)) + to_integer(unsigned(comp_regb));
						  elsif IR(1 downto 0) = "01" then
								if pipe4(49) = '1' then
									 temp_int <= to_integer(unsigned(rega_extended)) + to_integer(unsigned(comp_regb));
								end if;
						  elsif IR(1 downto 0) = "10" then
								if pipe4(48) = '1' then
									 temp_int <= to_integer(unsigned(rega_extended)) + to_integer(unsigned(comp_regb));
								end if;
						  elsif IR(1 downto 0) = "11" then
								temp_int <= to_integer(unsigned(rega_extended)) + to_integer(unsigned(comp_regb)) + to_integer(unsigned(tempc_extended));
						  end if;
					 end if;
					 
					 temp <= std_logic_vector(to_unsigned(temp_int, 17));
					 
					 if temp(15 downto 0) = "0000000000000000" then
						  Zout <= '1';
					 else
						  Zout <= '0';
					 end if;
					 
					 Cout <= temp(16);
					 OUTPUT <= temp(15 downto 0);
					 
				when "0010" =>   -- 6 cases for nand
					 if IR(2) = '0' then
						  if IR(1 downto 0) = "00" then
								temp <= rega_extended nand regb_extended;
						  elsif IR(1 downto 0) = "01" then
								if pipe4(49) = '1' then
									 temp <= rega_extended nand regb_extended;
								end if;
						  elsif IR(1 downto 0) = "10" then
								if pipe4(48) = '1' then
									 temp <= rega_extended nand regb_extended;
								end if;
						  end if;
					 elsif IR(2) = '1' then
						  if IR(1 downto 0) = "00" then
								temp <= rega_extended nand not comp_regb;
						  elsif IR(1 downto 0) = "01" then
								if pipe4(49) = '1' then
									 temp <= rega_extended nand not comp_regb;
								end if;
						  elsif IR(1 downto 0) = "10" then
								if pipe4(48) = '1' then
									 temp <= rega_extended nand not comp_regb;
								end if;
						  end if;
					 end if;
					 
					 if temp(15 downto 0) = "0000000000000000" then
						  Zout <= '1';
					 else 
						  Zout <= '0';
					 end if;
					 
					 OUTPUT <= temp(15 downto 0);
					 
				when "0000" =>
					 temp_int <= to_integer(unsigned(rega_extended)) + to_integer(unsigned(se_imm_padd));
					 temp <= std_logic_vector(to_unsigned(temp_int, 17));
						
					 if temp(15 downto 0) = "0000000000000000" then
						  Zout <= '1';
					 else
						  Zout <= '0';
					 end if;
					 Cout <= temp(16);
					 OUTPUT <= temp(15 downto 0);   
--				 
----				when "0100"	=> -- output is address in memory, memory pe value hain use rega mein dalna hain
----					 temp_int <= to_integer(unsigned(regb_extended)) + to_integer(unsigned(se_imm_padd));
----					 temp <= std_logic_vector(to_unsigned(temp_int, 17));
----					 output <= temp(15 downto 0);
----					
----				when "0101"	=> -- output is address in memory, rega ka value us address pe dalna hain
----					 temp_int <= to_integer(unsigned(regb_extended)) + to_integer(unsigned(se_imm_padd));
----					 temp <= std_logic_vector(to_unsigned(temp_int, 17));
----					 output <= temp(15 downto 0);	
--				
--				when "1000" =>
					 
					 
				when others =>
					 null;  -- Handle other cases if needed
        end case;
    end process;
                
end Behavioral;