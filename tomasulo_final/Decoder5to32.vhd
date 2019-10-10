library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
entity Decoder5to32 is
    Port ( Input : in STD_LOGIC_VECTOR (4 downto 0);
           Output : out STD_LOGIC_VECTOR (31 downto 0));
end Decoder5to32;
architecture Structural of Decoder5to32 is
begin
	Output(0)<='0';
	Generator:
	for i in 1 to 31 generate
		with Input
			select Output(i) <= '1' when std_logic_vector(to_unsigned(i,5)),
								'0' when others;
	end generate Generator;
end Structural;