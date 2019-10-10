library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity Demux1to16 is
    Port (input : in  STD_LOGIC;
	  output : out  STD_LOGIC_VECTOR (15 downto 0);
	  control : in  STD_LOGIC_VECTOR (3 downto 0));
end Demux1to16;
architecture Structural of Demux1to16 is
	signal temp: std_logic_vector(15 downto 0);
begin
	output(0)<=input when control="0000"else'0';
	output(1)<=input when control="0001"else'0';
	output(2)<=input when control="0010"else'0';
	output(3)<=input when control="0011"else'0';
	output(4)<=input when control="0100"else'0';
	output(5)<=input when control="0101"else'0';
	output(6)<=input when control="0110"else'0';
	output(7)<=input when control="0111"else'0';
	output(8)<=input when control="1000"else'0';
	output(9)<=input when control="1001"else'0';
	output(10)<=input when control="1010"else'0';
	output(11)<=input when control="1011"else'0';
	output(12)<=input when control="1100"else'0';
	output(13)<=input when control="1101"else'0';
	output(14)<=input when control="1110"else'0';
	output(15)<=input when control="1111"else'0';
end Structural;