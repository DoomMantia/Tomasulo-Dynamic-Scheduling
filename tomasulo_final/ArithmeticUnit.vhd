library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;
use ieee.std_logic_arith.all;
use IEEE.NUMERIC_BIT;
use IEEE.NUMERIC_STD.all; 

entity ArithmeticUnit is
    Port ( Vj : in STD_LOGIC_VECTOR (31 downto 0);
           Vk : in STD_LOGIC_VECTOR (31 downto 0);
           Op : in STD_LOGIC_VECTOR (1 downto 0);
           DataOut : out STD_LOGIC_VECTOR (31 downto 0));
end ArithmeticUnit;

architecture Behavioral of ArithmeticUnit is

SIGNAL ADD : STD_LOGIC_VECTOR (31 downto 0);
SIGNAL SUB : STD_LOGIC_VECTOR (31 downto 0);
SIGNAL SL : STD_LOGIC_VECTOR (31 downto 0);

begin

ADD <= Vj + Vk ;
SUB <= Vj - Vk ;
SL(31 downto 1) <= Vj (30 downto 0);
SL(0) <= '0';

with Op select
	DataOut <= ADD when "00",
			   SUB when "01",
			   SL  when "10",
			   std_logic_vector(to_unsigned(0,32)) when others ;

end Behavioral;
