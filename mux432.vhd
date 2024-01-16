----------------------------------------------------------
-- MUX432		                                        --
-- Max Santana                                          --
-- Antonio Filho	  (2023)                            --
-- CEComp/Univasf                                       --
----------------------------------------------------------

library ieee ;
use ieee.std_logic_1164.all;

entity mux432 is
  port(	
    d0, d1, d2, d3	:	in std_logic_vector(31 downto 0);
    s				: 	in std_logic_vector(1 downto 0);
    y				:	out std_logic_vector(31 downto 0)
  );
end mux432;

architecture behavior of mux432 is
begin
  y <= 	d0 when s = "00" else
 		d1 when s = "01" else
        d2 when s = "10" else 
        d3 when s = "11" ;
end behavior;