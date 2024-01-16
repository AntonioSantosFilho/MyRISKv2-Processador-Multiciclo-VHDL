----------------------------------------------------------
-- Max Santana                                          --
-- Antonio Filho	  (2023)                            --
-- CEComp/Univasf                                       --
----------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity decode is
	port(
		clk			: in std_logic;
        rst			: in std_logic;
    	regDst		: in std_logic;
    	memToReg	: in std_logic;
   		regWrite	: in std_logic;
    	rs			: in std_logic_vector(4 downto 0);
    	rt			: in std_logic_vector(4 downto 0);
    	rd			: in std_logic_vector(4 downto 0);
    	imm			: in std_logic_vector(15 downto 0);
    	memDR		: in std_logic_vector(31 downto 0);
    	aluOut		: in std_logic_vector(31 downto 0);
        immExt		: out std_logic_vector(31 downto 0);
    	Aout		: out std_logic_vector(31 downto 0);
    	Bout		: out std_logic_vector(31 downto 0)
    );
end decode;

architecture behavior of decode is
	signal wireWR		: std_logic_vector(4 downto 0);
    signal writeData	: std_logic_vector(31 downto 0);
    signal readData1	: std_logic_vector(31 downto 0);
    signal readData2	: std_logic_vector(31 downto 0);
begin

	EXTENDIMM: process(imm)
    begin 
    	if(imm(15)='1') then
	  		immExt(15 downto 0)  <= imm(15 downto 0);
	  		immExt(31 downto 16) <= "1111111111111111";
    	else 
	  		immExt(15 downto 0)  <= imm(15 downto 0);
	  		immExt(31 downto 16) <= "0000000000000000";
    	end if;
  	end process EXTENDIMM;
    
    MUXWR: entity work.mux25 port map (
    	d0	=> rt,
        d1	=> rd,
        s	=> regDst,
        y	=> wireWR
    );
    
    MUXWD: entity work.mux232 port map (
    	d0	=> aluOut,
        d1	=> memDR,
        s	=> memToReg,
        y	=> writeData
    );

	CPUREGISTERS: entity work.registers port map (
    	clock => clk,
    	reset => rst,
    	rr1   => rs,			-- read register 1 (RS)
    	rr2   => rt, 			-- read register 2 (RT)
    	rw    => regWrite,      -- read or write on register
    	wr    => wireWR,  		-- register for write
    	wd 	  => writeData,     -- write data
    	rd1	  => readData1,     -- read data 1
    	rd2	  => readData2      -- read data 2
	);
    
    Areg: entity work.reg port map (
    	clk		=> clk,
    	input	=> readData1,
        output	=> Aout
    );
    
    Breg: entity work.reg port map (
    	clk		=> clk,
        input	=> readData2,
        output	=> Bout
    );
  
end behavior;