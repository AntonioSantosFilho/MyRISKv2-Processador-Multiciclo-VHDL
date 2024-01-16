----------------------------------------------------------------------------------------------
-- ALU CONTROL              								                                --
--														                                    --
-- myRISC												                                    --
-- Prof. Max Santana  (2023)                                                                --
-- CEComp/Univasf                                                                           --
----------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity aluControl is 
  port( AluOP: in std_logic_vector(1 downto 0);
        funct:    in std_logic_vector(5 downto 0);
        oper:  out std_logic_vector(2 downto 0)
      );
      
  end aluControl;
    
architecture behavior of aluControl is
begin
  
  process(aluOP,funct)
  begin
    Oper(2) <= ( aluOP(0) or ( aluOP(1)and funct(1)));
    Oper(1) <= ( not(aluOP(1)) or not(funct(2)));
    Oper(0) <= (( aluOP(1) )and( funct(3) or funct(0)));
  end process;
    
end behavior;