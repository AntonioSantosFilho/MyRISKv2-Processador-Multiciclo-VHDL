----------------------------------------------------------
-- Max Santana                                          --
-- Antonio Filho	  (2023)                            --
-- CEComp/Univasf                                       --
----------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity memoryAccess is
    port(
    	clk			: in std_logic;
    	memWrite	: in std_logic;
        Bout		: in std_logic_vector(31 downto 0);
    	aluOut		: in std_logic_vector(31 downto 0);
    	memDR		: out std_logic_vector(31 downto 0)
    );
end memoryAccess;

architecture behavior of memoryAccess is
	signal memoryData	: std_logic_vector(31 downto 0);
begin

    DATAMEMORY: entity work.ram port map (
    	datain  => Bout,
    	address => aluOut,
    	clk		=> clk,
    	write   => memWrite, -- write when 1, read when 0
    	dataout => memoryData
    );
  
	MDreg: entity work.reg port map (
    	clk		=> clk,
    	input	=> memoryData,
        output	=> memDR
    );
    
end behavior;