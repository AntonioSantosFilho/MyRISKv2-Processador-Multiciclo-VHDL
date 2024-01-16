----------------------------------------------------------
-- Max Santana                                          --
-- Antonio Filho	  (2023)                            --
-- CEComp/Univasf                                       --
----------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity reg is
    port(
    	clk		: in std_logic;
    	input	: in std_logic_vector (31 downto 0);
        output	: out std_logic_vector (31 downto 0)
	);
end reg;

architecture behavior of reg is
begin
	process(input, clk)
	begin
		if falling_edge(clk) then
			output <= input;
		end if;
	end process;

end behavior;