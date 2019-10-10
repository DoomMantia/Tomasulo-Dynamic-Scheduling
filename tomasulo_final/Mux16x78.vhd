library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.STD_LOGIC_UNSIGNED.all;
use work.Bus32pkg.ALL;

entity Mux16x78 is
    Port (		Input : in Bus16x78;
				Sel : in  STD_LOGIC_VECTOR (3 downto 0);
				Output : out  STD_LOGIC_VECTOR (77 downto 0));
end Mux16x78;
architecture Behavioral of Mux16x78 is
begin
	with Sel select
		output <= 	Input(0) when std_logic_vector(to_unsigned(0,4)),
					Input(1) when std_logic_vector(to_unsigned(1,4)),
					Input(2) when std_logic_vector(to_unsigned(2,4)),
					Input(3) when std_logic_vector(to_unsigned(3,4)),
					Input(4) when std_logic_vector(to_unsigned(4,4)),
					Input(5) when std_logic_vector(to_unsigned(5,4)),
					Input(6) when std_logic_vector(to_unsigned(6,4)),
					Input(7) when std_logic_vector(to_unsigned(7,4)),
					Input(8) when std_logic_vector(to_unsigned(8,4)),
					Input(9) when std_logic_vector(to_unsigned(9,4)),
					Input(10) when std_logic_vector(to_unsigned(10,4)),
					Input(11) when std_logic_vector(to_unsigned(11,4)),
					Input(12) when std_logic_vector(to_unsigned(12,4)),
					Input(13) when std_logic_vector(to_unsigned(13,4)),
					Input(14) when std_logic_vector(to_unsigned(14,4)),
					Input(15) when others;
end Behavioral;
