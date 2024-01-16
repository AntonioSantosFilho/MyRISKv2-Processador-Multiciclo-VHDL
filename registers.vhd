----------------------------------------------------------
-- Register		                                        --
-- Max Santana                                          --
-- Antonio Filho	  (2023)                            --
-- CEComp/Univasf                                       --
----------------------------------------------------------

library ieee ;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity registers is
  port(
    clock  	: in std_logic;
    reset  	: in std_logic;
    rr1   	: in std_logic_vector(4 downto 0);  -- read register 1
    rr2   	: in std_logic_vector(4 downto 0);  -- read register 2
    rw   	: in std_logic;  		     		-- read or write
    wr   	: in std_logic_vector(4 downto 0);  -- register for write
    wd 		: in std_logic_vector(31 downto 0); -- write data
    rd1		: out std_logic_vector(31 downto 0);-- read data 1
	rd2		: out std_logic_vector(31 downto 0) -- read data 2
  );
end registers;

architecture behavior of registers is
  -- use array to define the bunch of internal temporary signals
  type register_type is array (0 to 31) of std_logic_vector(31 downto 0);
  signal regs : register_type;signal zero	: std_logic_vector(31 downto 0);
begin
  process(clock, reset)
  begin
    if (falling_edge(reset)) then
      for i in 0 to 31 loop
        if (i = 29) then
          regs(29) <= x"000000FF";
        else
          regs(i) <= x"00000000";
        end if;
	  end loop;      
	elsif (falling_edge(clock)) and (rw = '1') then
      if (wr /= "00000") then
	   regs(to_integer(unsigned(wr))) <= wd;
      end if;
	end if;
  end process;

  rd1 <= regs(to_integer(unsigned(rr1)));
  rd2 <= regs(to_integer(unsigned(rr2)));
end behavior;