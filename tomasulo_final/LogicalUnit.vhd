library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;
use ieee.std_logic_arith.all;
use IEEE.NUMERIC_BIT;
use IEEE.NUMERIC_STD.all; 

entity LogicalUnit is
    Port ( Vj : in STD_LOGIC_VECTOR (31 downto 0);
           Vk : in STD_LOGIC_VECTOR (31 downto 0);
           Op : in STD_LOGIC_VECTOR (1 downto 0);
           DataOut : out STD_LOGIC_VECTOR (31 downto 0));
end LogicalUnit;

architecture Behavioral of LogicalUnit is

SIGNAL BITAND : STD_LOGIC_VECTOR (31 downto 0);
SIGNAL BITOR : STD_LOGIC_VECTOR (31 downto 0);
SIGNAL BITNOT : STD_LOGIC_VECTOR (31 downto 0);

begin

BITAND <= Vj AND Vk ;
BITOR <= Vj OR Vk ;
BITNOT <= NOT Vj ;

with Op select
	DataOut <= BITOR when "00",
			   BITAND when "01",
			   BITNOT  when "10",
			   std_logic_vector(to_unsigned(0,32)) when others ;

end Behavioral;
