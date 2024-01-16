----------------------------------------------
-- ALU                 						--
--											--
-- myRISC									--
-- Prof. Max Santana  (2023)                --
-- CEComp/Univasf                           --
----------------------------------------------

library ieee ;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity alu is
  port ( 
    regA   : in  std_logic_vector (31 downto 0);	
    regB   : in  std_logic_vector (31 downto 0);	
    oper   : in  std_logic_vector (2 downto 0);	 -- function
	result : out std_logic_vector (31 downto 0); -- Result  
    zero   : out std_logic     					 -- zero
  );
end alu;

architecture behavior of alu is
signal iRegA, iRegB, iResult : STD_LOGIC_VECTOR(32 downto 0);
signal SS                    : STD_LOGIC_VECTOR(31 downto 0);
begin
  process (RegA, RegB, oper)
  begin
    case oper is
      when "010" => -- add
        Result <= RegA + RegB;
      when "110" => -- sub
        Result<= RegA + (not(RegB)) + 1;
        if ((RegA + (not(RegB)) + 1) = x"00000000") then 
          Zero<='1';
        else
          Zero<='0';
        end if;
      when "000" => -- and
        Result<= ((RegA) and (RegB)); 
      when "001" => -- or
        Result<= ((RegA) or (RegB));
      when "011" => -- jr
        Result<= RegA;
      when "100" => -- xor
        Result<= ((RegA) xor (RegB));      
      when "111" => -- slt 
        if (RegA < RegB) then 
          Result <= x"00000001"; 
        else 
          Result <= x"00000000";
        end if;
      when others => -- 
        Result <= x"00000000";
    end case;
  end process;
end behavior;