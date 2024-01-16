----------------------------------------------------------
-- Max Santana                                          --
-- Antonio Filho	  (2023)                            --
-- CEComp/Univasf                                       --
----------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity control is
  port(
  	clk		 : in std_logic;
    rst	 	 : in std_logic;
    op		 : in std_logic_vector(5 downto 0);
    branch	 : out std_logic;
    PCWrite	 : out std_logic;
    memWrite : out std_logic;
    memToReg : out std_logic;
    IRWrite  : out std_logic;
    PCSource : out std_logic_vector(1 downto 0);
    aluOp	 : out std_logic_vector(1 downto 0); 
    aluSrcA	 : out std_logic;
    aluSrcB	 : out std_logic_vector(1 downto 0);
    regWrite : out std_logic;
    regDst	 : out std_logic;
    state	 : out std_logic_vector(3 downto 0)
  );
end control;

architecture behavior of control is
	
    type FSM is (s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11);
    signal current_state, next_state: FSM;
    
begin

	process(clk, rst)
    begin
    	if (falling_edge(rst)) then
        	current_state <= s0;
            state <= "0000";
        
    	elsif (falling_edge(clk)) then
    		case(next_state) is
        		when  s0 => state <= "0000";
            	when  s1 => state <= "0001";
            	when  s2 => state <= "0010";
            	when  s3 => state <= "0011";
            	when  s4 => state <= "0100";
            	when  s5 => state <= "0101";
            	when  s6 => state <= "0110";
            	when  s7 => state <= "0111";
            	when  s8 => state <= "1000";
            	when  s9 => state <= "1001";
            	when s10 => state <= "1010";
            	when s11 => state <= "1011";
        	end case;
    	current_state <= next_state;
    	end if;
    end process;
            
    process(current_state)
    begin
    	case(current_state) is
        	when s0 =>		--Fetch
                aluSrcA		<= '0';
                aluSrcB		<= "01";
                aluOp		<= "00";
                PCSource	<= "00";
                IRWrite		<= '1';
                PCWrite		<= '1';
                next_state	<= s1;
                
                branch		<= 'X';
    			memWrite	<= 'X';
    			memToReg	<= 'X';
    			regWrite	<= 'X';
   			 	regDst		<= 'X';
                
            when s1 =>		--Decode
            	aluSrcA		<= '0';
                aluSrcB		<= "11";
                aluOP		<= "00";
                
                if op = ("100011" or "101011") then --LW or SW
                	next_state <= s2;
                elsif op = "000000"then	--R-Type
                	next_state <= s6;
                elsif op = "000100"then --BEQ
                	next_state <= s8;
                elsif op = "001000"then --ADDI
                	next_state <= s9;
                elsif op = "000010"then --J
                	next_state <= s11;
                end if;
                
                branch		<= 'X';
    			PCWrite		<= 'X';
    			memWrite	<= 'X';
    			memToReg	<= 'X';
    			IRWrite		<= 'X';
    			PCSource	<= "XX";
    			regWrite	<= 'X';
   			 	regDst		<= 'X';
                
            when s2 =>		--MemAdr
            	aluSrcA		<= '1';
                aluSrcB		<= "10";
                aluOP		<= "00";
                
                if op = "100011" then --LW
                	next_state <= s3;
                elsif op = "101011" then --SW
                	next_state <= s5;
                end if;
                
                branch		<= 'X';
    			PCWrite		<= 'X';
    			memWrite	<= 'X';
    			memToReg	<= 'X';
    			IRWrite		<= 'X';
    			PCSource	<= "XX";
    			regWrite	<= 'X';
   			 	regDst		<= 'X';
                
            when s3 =>		--MemRead
            	memWrite	<= '1';
                next_state	<= s4;
                
                branch		<= 'X';
    			PCWrite		<= 'X';
    			memToReg	<= 'X';
    			IRWrite		<= 'X';
    			PCSource	<= "XX";
    			aluOp		<= "XX";
    			aluSrcA		<= 'X';
    			aluSrcB		<= "XX";
    			regWrite	<= 'X';
   			 	regDst		<= 'X';
                
            when s4 =>		--MemWriteback
            	regDst		<= '0';
                memToReg	<= '1';
                regWrite	<= '1';
                next_state	<= s0;
                
                branch		<= 'X';
    			PCWrite		<= 'X';
    			memWrite	<= 'X';
    			IRWrite		<= 'X';
    			PCSource	<= "XX";
    			aluOp		<= "XX";
    			aluSrcA		<= 'X';
    			aluSrcB		<= "XX";
                
            when s5 =>		--MemWrite
                memWrite	<= '1';
                next_state	<= s0;
                
                branch		<= 'X';
    			PCWrite		<= 'X';
    			memToReg	<= 'X';
    			IRWrite		<= 'X';
    			PCSource	<= "XX";
    			aluOp		<= "XX";
    			aluSrcA		<= 'X';
    			aluSrcB		<= "XX";
    			regWrite	<= 'X';
   			 	regDst		<= 'X';
            
            when s6 =>		--Execute
            	aluSrcA		<= '1';
                aluSrcB		<= "00";
                aluOP		<= "10";
                next_state	<= s7;
                
                branch		<= 'X';
    			PCWrite		<= 'X';
    			memWrite	<= 'X';
    			memToReg	<= 'X';
    			IRWrite		<= 'X';
    			PCSource	<= "XX";
    			regWrite	<= 'X';
   			 	regDst		<= 'X';
                
            when s7 =>		--ALU Writeback
            	regDst		<= '1';
                memToReg	<= '0';
                regWrite	<= '1';
                next_state	<= s0;
                
                branch		<= 'X';
    			PCWrite		<= 'X';
    			memWrite	<= 'X';
    			IRWrite		<= 'X';
    			PCSource	<= "XX";
    			aluOp		<= "XX";
    			aluSrcA		<= 'X';
    			aluSrcB		<= "XX";
                
            when s8 =>		--Branch
                aluSrcA		<= '1';
                aluSrcB		<= "00";
                aluOP		<= "01";
                PCSource	<= "01";
                branch		<= '1';
                next_state	<= s0;
                
    			PCWrite		<= 'X';
    			memWrite	<= 'X';
    			memToReg	<= 'X';
    			IRWrite		<= 'X';
    			regWrite	<= 'X';
   			 	regDst		<= 'X';
                
            when s9 =>		--ADDI Execute
            	aluSrcA		<= '1';
                aluSrcB		<= "10";
                aluOP		<= "00";
                next_state	<= s10;
                
                branch		<= 'X';
    			PCWrite		<= 'X';
    			memWrite	<= 'X';
    			memToReg	<= 'X';
    			IRWrite		<= 'X';
    			PCSource	<= "XX";
    			regWrite	<= 'X';
   			 	regDst		<= 'X';
                
            when s10 =>		--ADDI Writeback
            	regDst		<= '0';
                memToReg	<= '0';
                regWrite	<= '1';
                next_state	<= s0;
                
                branch		<= 'X';
    			PCWrite		<= 'X';
    			memWrite	<= 'X';
    			IRWrite		<= 'X';
    			PCSource	<= "XX";
    			aluOp		<= "XX";
    			aluSrcA		<= 'X';
    			aluSrcB		<= "XX";
                
            when s11 =>		--Jump
            	PCSource	<= "10";
                PCWrite		<= '1';
                next_state	<= s0;
                
                branch		<= 'X';
    			memWrite	<= 'X';
    			memToReg	<= 'X';
    			IRWrite		<= 'X';
    			aluOp		<= "XX";
    			aluSrcA		<= 'X';
    			aluSrcB		<= "XX";
    			regWrite	<= 'X';
   			 	regDst		<= 'X';
                
        end case;
    end process;
end behavior;