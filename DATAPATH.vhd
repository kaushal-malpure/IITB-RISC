library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;
library work;



-----------------------entity------------------------------


entity DATAPATH is 
	port(clk, reset : in std_logic);
end entity DATAPATH;

---------------------components--------------------------



architecture beh of DATAPATH is

component pipeline_1 is
	port (input:in std_logic_vector(31 downto 0);
			reset : in std_logic;
			w_enable, clk: in std_logic;
			output: out std_logic_vector(31 downto 0));
end component pipeline_1;



component pipeline_2 is
	port (input:in std_logic_vector(31 downto 0);
			reset : in std_logic;
			w_enable, clk: in std_logic;
			output: out std_logic_vector(31 downto 0));
end component pipeline_2;



component pipeline_3 is
	port (input:in std_logic_vector(63 downto 0);
			reset : in std_logic;
			w_enable, clk: in std_logic;
			output: out std_logic_vector(63 downto 0));
end component pipeline_3;



component pipeline_4 is
	port (input:in std_logic_vector(49 downto 0);
			reset : in std_logic;
			w_enable, clk: in std_logic;
			output: out std_logic_vector(49 downto 0));
end component pipeline_4;



component pipeline_5 is
	port (input:in std_logic_vector(47 downto 0);
			reset : in std_logic;
			w_enable, clk: in std_logic;
			output: out std_logic_vector(47 downto 0));
end component pipeline_5;



component Alu is 
    port (
			  IR : in std_logic_vector(15 downto 0);   -- Operation select: 0001 for addition, 0010 for subtraction
			  REGA : in std_logic_vector(15 downto 0);
			  REGB : in std_logic_vector(15 downto 0);
			  OUTPUT : out std_logic_vector(15 downto 0);
			  PIPE4 : in std_logic_vector(49 downto 0);    -- [zflag(49),cflag(48),Regc(47-32),IR(31-16),IP(15-0)]
			  Z : out std_logic;
			  C : out std_logic
         );
end component Alu;



component ALU_2 is
    Port ( A : in  std_logic_vector(15 downto 0);
           result : out  std_logic_vector(15 downto 0)
			  );
end component ALU_2;



component Memory is
    port (
        clk : in std_logic;
        address : in std_logic_vector(15 downto 0);
        data_in : in std_logic_vector(15 downto 0);
        write_enable : in std_logic;
        data_out : out std_logic_vector(15 downto 0)
    );
end component Memory;



component LeftShifter is
    Port ( input : in std_logic_vector(15 downto 0);
           output : out std_logic_vector(15 downto 0)
          );
end component LeftShifter;



component REGISTER_FILE is
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
end component REGISTER_FILE;


------------------------------signals-----------------------------------


signal rf_wr, mem_wr, alu_z, alu_c,alu_wr_en : std_logic := '0';
signal p1_wr, p2_wr, p3_wr, p4_wr, p5_wr : std_logic := '1';
signal rf_wr_add, wr_add, rd_add1, rd_add2, alu_wr_add  :  std_logic_vector(2 downto 0);
signal wr_pc, rd_pc, rf_out1, rf_out2, lf_in, lf_out, mem_in, mem_out, inst,alu_a,alu_b,alu_out, alu_wr_data  : std_logic_vector(15 downto 0);
signal p4_in, p4_out : std_logic_vector(49 downto 0);
signal p1_in, p2_in, p1_out, p2_out : std_logic_vector(31 downto 0);
signal p3_in, p3_out : std_logic_vector(61 downto 0);
signal p5_in, p5_out : std_logic_vector(47 downto 0);
signal count_wr : integer := 0;
signal count_alu : integer := 0;
signal rf_wr_data :  std_logic_vector(15 downto 0);


----------------------------main code-----------------------------------
begin 
		
		
		RF: component Register_File
			port map(clk,reset,rf_wr,rf_wr_add,rf_wr_data,wr_pc,rd_add1,rd_add2,rd_pc,rf_out1,rf_out2,alu_wr_en, alu_wr_add, alu_wr_data);
			
		LF: component LeftShifter 	
			port map(lf_in, lf_out);
		
		MEM: component Memory
		   port map(clk,rd_pc,mem_in,mem_wr,mem_out);
			
		ALUU: component Alu
		   port map(inst,alu_a,alu_b,alu_out,p4_out,alu_z,alu_c);
		
	   ALUU_2 : component ALU_2
		   port map(rd_pc,wr_pc);	
			
		P1: component pipeline_1
		   port map( p1_in ,reset,p1_wr,clk,p1_out);
			
		P2: component pipeline_2
		   port map(p1_out,reset,p2_wr,clk,p2_out);
			
		P3: component pipeline_3
		   port map(p3_in,reset,p3_wr,clk,p3_out);
		
		P4: component pipeline_4
		   port map(p4_in,reset,p4_wr,clk,p4_out);
			
	   P5: component pipeline_5
		   port map(p5_in,reset,p5_wr,clk,p5_out);	
			
			
----------------------------process-----------------------------------		


	stage_1:process(clk,reset)	
			begin          --INSTRUCTION FETCH
					
					p1_in(15 downto 0) <= mem_out;
					p1_in(31 downto 16) <= rd_pc;
					
			end process;
			
	stage_2:process(clk,reset)
			begin			--INSTRUCTION DECODE
					
					p2_in <= p1_out ;
					
					end process;
							
	stage_3:process(clk,reset)
			begin			--REGISTER READ
					
					p3_in(31 downto 0) <= p2_out;
					rd_add1 <= p2_out(27 downto 25);
					rd_add2 <= p2_out(24 downto 22);
					p3_in(47 downto 32)  <= rf_out1;
					p3_in(63 downto 48)  <= rf_out2;
					
					end process;

	stage_4:process(clk,reset)
			begin			--EXECUTION
					
					p4_in(31 downto 0) <= p3_out(31 downto 0);
					p4_in(47 downto 32) <= alu_out;
					p4_in(48) <= alu_c;
					p4_in(49) <= alu_z;
					alu_wr_add <= p3_out(21 downto 19);
					alu_wr_data <= alu_out;
					
							if reset = '1' then
								count_alu <= 0;        -- Reset count when reset signal is asserted
								rf_wr <= '0';          -- Set write_enable to '0' on reset
							elsif rising_edge(clk) then
									if count_alu < 3 then
										 count_alu <= count_alu + 1;        -- Increment count on each rising clock edge
									else
										 rf_wr <= '1';       -- Set write_enable to '1' when count exceeds 5
									end if;
							end if;


					end process;

	stage_5:process(clk,reset)
			begin			--MEMORY
					
					p5_in(47 downto 0) <= p4_out(47 downto 0);

					end process;

	stage_6:process(clk,reset)
			begin			--WRITE
					
					rf_wr_add <= p5_out(21 downto 19);
					rf_wr_data <= p5_out(47 downto 32);
					
							if reset = '1' then
								count_wr <= 0;        -- Reset count when reset signal is asserted
								rf_wr <= '0';          -- Set write_enable to '0' on reset
							elsif rising_edge(clk) then
									if count_wr < 5 then
										 count_wr <= count_wr + 1;        -- Increment count on each rising clock edge
									else
										 rf_wr <= '1';       -- Set write_enable to '1' when count exceeds 5
									end if;
							end if;

					end process;					
					
end architecture;