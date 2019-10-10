library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.bus32pkg.all;
entity LdStQ is
    Port (
		DataIn		: in  std_logic_vector(31 downto 0);
		WriteAddr	: in  std_logic_vector(4 downto 0);
		WrEn		: in  std_logic;
		ReadAddr	: in  std_logic_vector(4 downto 0);
		Tag			: in  std_logic_vector(4 downto 0);
		Grant		: in  std_logic;
		Clk			: in  std_logic;
		Rst			: in  std_logic;
		Busy		: out std_logic;
		Request		: out std_logic;
		VOut		: out std_logic_vector(31 downto 0);
		QOut		: out std_logic_vector(4 downto 0)
	);
end LdStQ;
architecture Structural of LdStQ is
	component Register32 is
		Port ( 
			DataIn 	: in  STD_LOGIC_VECTOR (31 downto 0);
			WrEn 	: in  STD_LOGIC;
			Clk 	: in  STD_LOGIC;
			DataOut : out STD_LOGIC_VECTOR (31 downto 0);
			Rst 	: in  STD_LOGIC);
	end component;
	component Register5 is
		Port ( 
			DataIn 	: in STD_LOGIC_VECTOR (4 downto 0);
			WrEn 	: in STD_LOGIC;
			Rst 	: in STD_LOGIC;
			Clk 	: in STD_LOGIC;
			DataOut : out STD_LOGIC_VECTOR (4 downto 0));
	end component;
	component Register48 is
		Port ( 
			DataIn 	: in  STD_LOGIC_VECTOR (47 downto 0);
			WrEn 	: in  STD_LOGIC;
			Clk 	: in  STD_LOGIC;
			DataOut : out STD_LOGIC_VECTOR (47 downto 0);
			Rst 	: in  STD_LOGIC);
	end component;
	component BusMultiplexer32 is
		Port (
			Input 	: in Bus32;
			Sel 	: in  STD_LOGIC_VECTOR (4 downto 0);
			Output 	: out STD_LOGIC_VECTOR (31 downto 0));
	end component;
	component Decoder5to32 is
		Port ( 
			Input 	: in  STD_LOGIC_VECTOR (4 downto 0);
		    Output 	: out STD_LOGIC_VECTOR (31 downto 0));
	end component;
	
	signal delayReg1Input	: std_logic_vector(47 downto 0);
	signal delayReg2Input	: std_logic_vector(47 downto 0);
	signal delayReg2Output	: std_logic_vector(47 downto 0);
	signal DataInDelayed	: std_logic_vector(31 downto 0);
	signal WriteAddrDelayed	: std_logic_vector(4 downto 0);
	signal WrEnDelayed		: std_logic;
	signal ReadAddrDelayed	: std_logic_vector(4 downto 0);
	signal TagDelayed		: std_logic_vector(4 downto 0);
	signal DecoderOut		: std_logic_vector(31 downto 0);
	signal WrEnDecoded		: std_logic_vector(31 downto 0);
	signal register32Out 	: Bus32;
	signal delayReg1WrEn 	: std_logic;
	signal delayReg2WrEn 	: std_logic;
	signal delayReg1Nop 	: std_logic;
	signal delayReg2Nop 	: std_logic;
begin
	delayReg1Input(31 downto 0)		<= DataIn;
	delayReg1Input(36 downto 32)	<= WriteAddr;
	delayReg1Input(37)				<= WrEn;
	delayReg1Input(42 downto 38)	<= ReadAddr;
	delayReg1Input(47 downto 43)	<= Tag;

	delayREG1: Register48 port map(
		DataIn	=> delayReg1Input, 
		WrEn	=> delayReg1WrEn, 
		Clk		=> Clk, 
		DataOut	=> delayReg2Input, 
		Rst		=> Rst);

	delayREG2: Register48 port map(
		DataIn	=> delayReg2Input, 
		WrEn	=> delayReg2WrEn, 
		Clk		=> Clk, 
		DataOut	=> delayReg2Output, 
		Rst		=> Rst);

	DataInDelayed		<= delayReg2Output(31 downto 0);
	WriteAddrDelayed	<= delayReg2Output(36 downto 32);
	WrEnDelayed			<= delayReg2Output(37);
	ReadAddrDelayed		<= delayReg2Output(42 downto 38);
	TagDelayed			<= delayReg2Output(47 downto 43);

	decoder: Decoder5to32 Port map(
		Input	=> WriteAddrDelayed, 
		Output	=> DecoderOut);

	Register32Generator:
	for i in 0 to 31 generate
		WrEnDecoded(i) <= DecoderOut(i) and WrEnDelayed;
		register32_i: Register32 port map(
			DataIn	=> DataInDelayed, 
			WrEn	=> WrEnDecoded(i), 
			Clk		=> Clk, 
			DataOut	=> register32Out(i), 
			Rst		=> Rst);
	end generate;
	
	BusMux32_DataOut1: BusMultiplexer32 port map(
		Input	=> register32Out, 
		Sel		=> ReadAddrDelayed, 
		Output	=> VOut);

	TagReg0: Register5 Port Map ( 
		DataIn 	=> TagDelayed,
		WrEn 	=> Grant,
		Clk 	=> Clk,
		DataOut => QOut,
		Rst 	=> Rst);

	with delayReg2Input(47 downto 43) select
		delayReg1Nop <= '1' when "00000",
						'0' when others;
	
	with delayReg2Output(47 downto 43) select
		delayReg2Nop <= '1' when "00000",
						'0' when others;

	Request			<= not delayReg2Nop;			
	delayReg1WrEn 	<= Grant OR delayReg1Nop OR delayReg2Nop;
	delayReg2WrEn 	<= Grant OR delayReg1Nop;
	Busy 			<= (delayReg1Nop NOR delayReg2Nop) AND (NOT Grant);
end Structural;