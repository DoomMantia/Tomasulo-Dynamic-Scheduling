library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
package Bus32pkg is
	type Bus32 	 is array 	(31 downto 0) 	of STD_LOGIC_VECTOR (31 downto 0);
	type Bus16 	 is array 	(15 downto 0) 	of STD_LOGIC_VECTOR (31 downto 0);
	type Bus8 	 is array 	(7 downto 0) 	of STD_LOGIC_VECTOR (31 downto 0);
	type Bus4 	 is array 	(3 downto 0) 	of STD_LOGIC_VECTOR (31 downto 0);
	type Bus2 	 is array 	(1 downto 0) 	of STD_LOGIC_VECTOR (31 downto 0);
	type Bus32x5 is array 	(31 downto 0) 	of STD_LOGIC_VECTOR (4 downto 0);
	type Bus16x78 is array 	(15 downto 0) 	of STD_LOGIC_VECTOR (77 downto 0);
	type Bus16x2 is array 	(15 downto 0) 	of STD_LOGIC_VECTOR (1 downto 0);
	type Bus16x5 is array 	(15 downto 0) 	of STD_LOGIC_VECTOR (4 downto 0);
end package;