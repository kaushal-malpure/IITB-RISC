library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tryAlu is 
    port (
        IR : in std_logic_vector(15 downto 0);   -- Operation select: 0001 for addition, 0010 for subtraction
        REGA : in std_logic_vector(15 downto 0);
        REGB : in std_logic_vector(15 downto 0);
        cin : in std_logic;
        zin : in std_logic;
        OUTPUT : out std_logic_vector(15 downto 0);
        Zout : out std_logic;
        Cout : out std_logic
    );
end tryAlu;

architecture Behavioral of tryAlu is
    signal temp : std_logic_vector(15 downto 0);
    signal rega_extended, regb_extended, tempc_extended, tempz_extended, comp_regb : std_logic_vector(16 downto 0);
    signal se_imm_padd : std_logic_vector(16 downto 0);
    
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

    extend1 : Padder1plus16 port map(REGA, rega_extended);
    extend2 : Padder1plus16 port map(REGB, regb_extended);
    extend3 : Padder16plus1 port map(cin, tempc_extended);
    extend4 : Padder16plus1 port map(zin, tempz_extended);
    comp1 : Complementer port map(REGB, comp_regb);
    
    signExtend1 : sign_extender_10plus6 port map(IR(5 downto 0), se_imm_padd);
    
    process (IR, REGA, REGB, rega_extended, regb_extended, comp_regb, tempc_extended, tempz_extended, se_imm_padd)
    begin
        case IR(15 downto 12) is
            when "0001" =>   -- 8 cases for add
                if IR(2) = '0' then
                    if IR(1 downto 0) = "00" then
                        temp <= rega_extended + regb_extended;
                    elsif IR(1 downto 0) = "01" then
                        if zin = '1' then
                            temp <= rega_extended + regb_extended;
                        end if;
                    elsif IR(1 downto 0) = "10" then
                        if cin = '1' then
                            temp <= rega_extended + regb_extended;
                        end if;
                    elsif IR(1 downto 0) = "11" then
                        temp <= rega_extended + regb_extended + tempc_extended;
                    end if;
                elsif IR(2) = '1' then
                    if IR(1 downto 0) = "00" then
                        temp <= rega_extended + comp_regb;
                    elsif IR(1 downto 0) = "01" then
                        if zin = '1' then
                            temp <= rega_extended + comp_regb;
                        end if;
                    elsif IR(1 downto 0) = "10" then
                        if cin = '1' then
                            temp <= rega_extended + comp_regb;
                        end if;
                    elsif IR(1 downto 0) = "11" then
                        temp <= rega_extended + comp_regb + tempc_extended;
                    end if;
                end if;
                
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
                        if zin = '1' then
                            temp <= rega_extended nand regb_extended;
                        end if;
                    elsif IR(1 downto 0) = "10" then
                        if cin = '1' then
                            temp <= rega_extended nand regb_extended;
                        end if;
                    end if;
                elsif IR(2) = '1' then
                    if IR(1 downto 0) = "00" then
                        temp <= rega_extended nand not comp_regb;
                    elsif IR(1 downto 0) = "01" then
                        if zin = '1' then
                            temp <= rega_extended nand not comp_regb;
                        end if;
                    elsif IR(1 downto 0) = "10" then
                        if cin = '1' then
                            temp <= rega_extended nand not comp_regb;
                        end if;
                    end if;
                end if;
                
                if temp = "0000000000000000" then
                    Zout <= '1';
                else 
                    Zout <= '0';
                end if;
                
                OUTPUT <= temp;
                
            when "0000" =>
                temp <= rega_extended + se_imm_padd;
                if temp(15 downto 0) = "0000000000000000" then
                    Zout <= '1';
                else
                    Zout <= '0';
                end if;
                Cout <= temp(16);
                OUTPUT <= temp(15 downto 0);   
                
            when others =>
                null;  -- Handle other cases if needed
        end case;
    end process;
                
end Behavioral;
