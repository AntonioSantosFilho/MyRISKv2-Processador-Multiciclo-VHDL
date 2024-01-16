----------------------------------------------------------
-- Max Santana                                          --
-- Antonio Filho	  (2023)                            --
-- CEComp/Univasf                                       --
----------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity execute is
	port(
    	clk		: in std_logic;
    	aluSrcA	: in std_logic;
        aluSrcB	: in std_logic_vector(1 downto 0);
    	aluOp	: in std_logic_vector(1 downto 0);
        funct	: in std_logic_vector(5 downto 0);
        addr	: in std_logic_vector(25 downto 0);
        immExt	: in std_logic_vector(31 downto 0);
    	Aout	: in std_logic_vector(31 downto 0);
        Bout	: in std_logic_vector(31 downto 0);
        PCplus4	: in std_logic_vector(31 downto 0);
        zero	: out std_logic;
        result	: out std_logic_vector(31 downto 0);
        aluOut	: out std_logic_vector(31 downto 0);
        jumpAddr: out std_logic_vector(31 downto 0)
    );
end execute;

architecture behavior of execute is
	signal wireOper		: std_logic_vector(2 downto 0);
	signal wireA, wireB	: std_logic_vector(31 downto 0);
begin

	JUMPER: process(PCplus4, addr)
  	begin
    	JumpAddr(1 downto 0)   <= "00";
    	JumpAddr(27 downto 2)  <= addr(25 downto 0) ;
    	JumpAddr(31 downto 28) <= PCplus4(31 downto 28);
  	end process JUMPER;

	MUXA: entity work.mux232 port map (
    	d0	=> PCplus4,
    	d1	=> Aout,
        s	=> aluSrcA,
        y	=> wireA
    );
    
    MUXB: entity work.mux432 port map (
    	d0	=> Bout,
        d1	=> x"00000004",
        d2	=> immExt,
        d3	=> immExt sll 2,
        s	=> aluSrcB,
        y	=> wireB
    );

	ALUCTRL: entity work.alucontrol port map (
    	aluOp => aluOp,
    	funct => funct,
    	oper  => wireOper
	);

	ALURISC: entity work.alu port map (
		regA   => wireA,	
    	regB   => wireB,	
    	oper   => wireOper,
		result => result, 
    	zero   => zero
	);
    
    ALUOUTREG: entity work.reg port map (
    	clk		=> clk,
        input	=> result,
        output	=> aluOut
    );
  
end behavior;