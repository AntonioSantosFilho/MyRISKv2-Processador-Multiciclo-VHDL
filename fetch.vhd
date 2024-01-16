----------------------------------------------------------
-- Max Santana                                          --
-- Antonio Filho	  (2023)                            --
-- CEComp/Univasf                                       --
----------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity fetch is
    port(
    	clk			: in std_logic;
    	rst        	: in std_logic;
        branch		: in std_logic;
        PCWrite		: in std_logic;
        zero		: in std_logic;
        PCSource	: in std_logic_vector(1 downto 0);
        result		: in std_logic_vector(31 downto 0);
        aluOut		: in std_logic_vector(31 downto 0);
        jumpAddr	: in std_logic_vector(31 downto 0);
        inst		: out std_logic_vector(31 downto 0);
        PCplus4		: out std_logic_vector(31 downto 0)
	);
end fetch;

architecture behavior of fetch is
  signal wireInstAddr, wireNextPC: std_logic_vector(31 downto 0);
begin
    
	MUXFETCH: entity work.mux332 port map (
    	d0	=> result,
        d1	=> aluOut,
        d2	=> JumpAddr,
        s	=> PCSource,
        y	=> wireNextPC
    );

    PC: entity work.rreg32 port map (
    	clk		=> clk, 
    	rst		=> rst,
        load	=> (branch and zero) or PCWrite,
    	d		=> wireNextPC,
    	q		=> wireInstAddr
    );
  
    IMEMORY: entity work.rom port map (
    	address => wireInstAddr,
    	data    => inst
    );
    
    PCplus4 <= wireInstAddr;
end behavior;