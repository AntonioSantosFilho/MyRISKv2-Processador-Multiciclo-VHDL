----------------------------------------------------------
-- Max Santana                                          --
-- Antonio Filho	  (2023)                            --
-- CEComp/Univasf                                       --
----------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity design is
	port(
    	clk	  : in std_logic;
        rst	  : in std_logic;
        state : out std_logic_vector(3 downto 0)
    );
end design;

architecture behavior of design is

	signal wireBranch, wirePCWrite, wireMemWrite, wireMemToReg, wireIRWrite, wireAluSrcA, wireRegWrite, wireRegDst, wireZero	: std_logic;
	
    signal wirePCSource, wireAluOp, wireAluSrcB	: std_logic_vector(1 downto 0);
    
    signal wireRS, wireRT, wireRD	: std_logic_vector(4 downto 0);
    
	signal wireOP, wireFunct	: std_logic_vector(5 downto 0);
    
    signal wireImm	: std_logic_vector(15 downto 0);
    
    signal wireAddr	: std_logic_vector(25 downto 0);
    
    signal wireMemDR, wireImmExt, wireAluOut, wireAout, wireBout, wirePCplus4, wireResult, wireJumpAddr, wireInst	: std_logic_vector(31 downto 0);
	
    begin
    
    FSMCONTROL: entity work.control port map (
    	clk			=> clk,
    	rst			=> rst,
    	op			=> wireOP,
    	branch		=> wireBranch,
    	PCWrite		=> wirePCWrite,
    	memWrite	=> wireMemWrite,
    	memToReg	=> wireMemToReg,
    	IRWrite		=> wireIRWrite,
    	PCSource	=> wirePCSource,
    	aluOp		=> wireAluOp, 
    	aluSrcA		=> wireAluSrcA,
    	aluSrcB		=> wireAluSrcB,
    	regWrite	=> wireRegWrite,
    	regDst		=> wireRegDst,
    	state		=> state
    );
    
    IDECODE: entity work.decode port map (
    	clk			=> clk,
        rst			=> rst,
    	regDst		=> wireRegDst,
    	memToReg	=> wireMemToReg,
    	regWrite	=> wireRegWrite,
    	rs			=> wireRS,
    	rt			=> wireRT,
    	rd			=> wireRD,
    	imm			=> wireImm,
    	memDR		=> wireMemDr,
        immExt		=> wireImmExt,
    	aluOut		=> wireAluOut,
    	Aout		=> wireAout,
    	Bout		=> wireBout
    );
    
    IEXECUTE: entity work.execute port map (
    	clk			=> clk,
    	aluSrcA		=> wireAluSrcA,
        aluSrcB		=> wireAluSrcB,
    	aluOp		=> wireAluOp,
        funct		=> wireFunct,
        addr		=> wireAddr,
        immExt		=> wireImmExt,
    	Aout		=> wireAout,
        Bout		=> wireBout,
        PCplus4		=> wirePCplus4,
        zero		=> wireZero,
        result		=> wireResult,
        aluOut		=> wireAluOut,
        jumpAddr	=> wireJumpAddr
    );
    
    IFETCH: entity work.fetch port map (
    	clk			=> clk,
    	rst			=> rst,
        PCSource	=> wirePCSource,
        branch		=> wireBranch,
        PCWrite		=> wirePCWrite,
        zero		=> wireZero,
        result		=> wireResult,
        aluOut		=> wireAluOut,
        jumpAddr	=> wireJumpAddr,
        inst		=> wireInst,
        PCplus4		=> wirePCplus4
	);
    
    IREG: entity work.ireg port map (
    	clk			=> clk,
    	IRWrite		=> wireIRWrite,
    	inst		=> wireInst,
    	op			=> wireOP,
    	addr		=> wireAddr,
    	rs			=> wireRS,
    	rt			=> wireRT,
    	rd			=> wireRD,
    	imm			=> wireImm,
    	funct		=> wireFunct
    );
    
    IMEMORYACCESS: entity work.memoryAccess port map(
    	clk			=> clk,
    	memWrite	=> wireMemWrite,
        Bout		=> wireBout,
    	aluOut		=> wireAluOut,
    	memDR		=> wireMemDr
    );
    
end behavior;