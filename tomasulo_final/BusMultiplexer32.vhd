library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.STD_LOGIC_UNSIGNED.all;
use work.Bus32pkg.ALL;
entity BusMultiplexer32 is
    Port (		Input : in Bus32;
				Sel : in  STD_LOGIC_VECTOR (4 downto 0);
				Output : out  STD_LOGIC_VECTOR (31 downto 0));
end BusMultiplexer32;
architecture Behavioral of BusMultiplexer32 is
begin
	with Sel select
		output <= 	Input(0) when std_logic_vector(to_unsigned(0,5)),
					Input(1) when std_logic_vector(to_unsigned(1,5)),
					Input(2) when std_logic_vector(to_unsigned(2,5)),
					Input(3) when std_logic_vector(to_unsigned(3,5)),
					Input(4) when std_logic_vector(to_unsigned(4,5)),
					Input(5) when std_logic_vector(to_unsigned(5,5)),
					Input(6) when std_logic_vector(to_unsigned(6,5)),
					Input(7) when std_logic_vector(to_unsigned(7,5)),
					Input(8) when std_logic_vector(to_unsigned(8,5)),
					Input(9) when std_logic_vector(to_unsigned(9,5)),
					Input(10) when std_logic_vector(to_unsigned(10,5)),
					Input(11) when std_logic_vector(to_unsigned(11,5)),
					Input(12) when std_logic_vector(to_unsigned(12,5)),
					Input(13) when std_logic_vector(to_unsigned(13,5)),
					Input(14) when std_logic_vector(to_unsigned(14,5)),
					Input(15) when std_logic_vector(to_unsigned(15,5)),
					Input(16) when std_logic_vector(to_unsigned(16,5)),
					Input(17) when std_logic_vector(to_unsigned(17,5)),
					Input(18) when std_logic_vector(to_unsigned(18,5)),
					Input(19) when std_logic_vector(to_unsigned(19,5)),
					Input(20) when std_logic_vector(to_unsigned(20,5)),
					Input(21) when std_logic_vector(to_unsigned(21,5)),
					Input(22) when std_logic_vector(to_unsigned(22,5)),
					Input(23) when std_logic_vector(to_unsigned(23,5)),
					Input(24) when std_logic_vector(to_unsigned(24,5)),
					Input(25) when std_logic_vector(to_unsigned(25,5)),
					Input(26) when std_logic_vector(to_unsigned(26,5)),
					Input(27) when std_logic_vector(to_unsigned(27,5)),
					Input(28) when std_logic_vector(to_unsigned(28,5)),
					Input(29) when std_logic_vector(to_unsigned(29,5)),
					Input(30) when std_logic_vector(to_unsigned(30,5)),
					Input(31) when others;
end Behavioral;
