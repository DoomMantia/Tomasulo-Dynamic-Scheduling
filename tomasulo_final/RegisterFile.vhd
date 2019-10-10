library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.Bus32pkg.ALL;
use IEEE.NUMERIC_STD.ALL;
entity RegisterFile is
	Port( 
		ReadAddr1 	: in STD_LOGIC_VECTOR (4 downto 0);
		ReadAddr2 	: in STD_LOGIC_VECTOR (4 downto 0);
		AddrW 		: in STD_LOGIC_VECTOR (4 downto 0);
		RFWrData 	: in STD_LOGIC_VECTOR (31 downto 0);
		WrEn 		: in STD_LOGIC;
		Clk 		: in STD_LOGIC;
		Rst 		: in STD_LOGIC;
		DataOut1	: out STD_LOGIC_VECTOR (31 downto 0);
		DataOut2 	: out STD_LOGIC_VECTOR (31 downto 0));
end RegisterFile;
architecture Structural of RegisterFile is
	component Register32 is
		Port ( 
			DataIn 	: in STD_LOGIC_VECTOR (31 downto 0);
			WrEn 	: in STD_LOGIC;
			Clk 	: in STD_LOGIC;
			DataOut : out STD_LOGIC_VECTOR (31 downto 0);
			Rst 	: in STD_LOGIC);
	end component;
	component BusMultiplexer32 is
		Port (
			Input 	: in Bus32;
			Sel 	: in  STD_LOGIC_VECTOR (4 downto 0);
			Output 	: out  STD_LOGIC_VECTOR (31 downto 0));
	end component;
	component Decoder5to32 is
		Port ( 
			Input 	: in STD_LOGIC_VECTOR (4 downto 0);
		    Output 	: out STD_LOGIC_VECTOR (31 downto 0));
	end component;
	
	signal register32Out : Bus32;
	signal DecoderOut, RFWrEnSignal: std_logic_vector(31 downto 0);
begin
	decoder: Decoder5to32 Port map(Input=>AddrW, Output=>DecoderOut);
	register32Out(0)<=std_logic_vector(to_unsigned(0,32));
	RFWrEnSignal(0)<='0';
	Register32Generator:
	for i in 1 to 31 generate
		RFWrEnSignal(i)<=DecoderOut(i) and WrEn;
		register32_i: Register32 port map(DataIn=>RFWrData, WrEn=>RFWrEnSignal(i), Clk=>Clk, DataOut=>register32Out(i), Rst=>Rst);
	end generate;
	BusMux32_DataOut1: BusMultiplexer32 port map(Input=>register32Out, Sel=>ReadAddr1, Output=>DataOut1);
	BusMux32_DataOut2: BusMultiplexer32 port map(Input=>register32Out, Sel=>ReadAddr2, Output=>DataOut2);
end Structural;