library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;
use ieee.std_logic_arith.all;
use IEEE.NUMERIC_BIT;
use IEEE.NUMERIC_STD.all; 
use work.Bus32pkg.ALL;

entity ReorderBuffer is
	Port(   InstrTypeIn     : in std_logic_vector(1 downto 0);
		    DestinationIn   : in std_logic_vector(4 downto 0);
            TagIn           : in std_logic_vector(4 downto 0);
            PCIn            : in std_logic_vector(31 downto 0);
            ExceptionIn     : in std_logic;
            CDBQ            : in std_logic_vector(4 downto 0);
            CDBV            : in std_logic_vector(31 downto 0);		
            WrEn            : in std_logic;
            ReadAddr1       : in std_logic_vector(4 downto 0);
            ReadAddr2       : in std_logic_vector(4 downto 0);
            Clk             : in std_logic;
            Rst             : in std_logic;
            RFAddr          : out std_logic_vector(4 downto 0);
            RFWrData        : out std_logic_vector(31 downto 0);
            RFWrEn          : out std_logic;
         	Exc 			: out std_logic;
            InstrTypeOut    : out std_logic_vector(1 downto 0);
            PCOut           : out std_logic_vector(31 downto 0);
            FullOut         : out std_logic;
            DataOut1        : out STD_LOGIC_VECTOR (31 downto 0);
            TagOut1         : out STD_LOGIC_VECTOR (4 downto 0);
            Available1      : out std_logic;
            DataOut2        : out STD_LOGIC_VECTOR (31 downto 0);
            TagOut2         : out STD_LOGIC_VECTOR (4 downto 0);
            Available2      : out std_logic);
end ReorderBuffer;
architecture Structural of ReorderBuffer is

	component Mux16x78 Port(
		Input 	: in Bus16x78;
		Sel 	: in  STD_LOGIC_VECTOR (3 downto 0);
		Output 	: out  STD_LOGIC_VECTOR (77 downto 0));
	end component;

	component ReorderBufferBlock Port(
		InstrTypeIn		: in std_logic_vector(1 downto 0);
		DestinationIn	: in std_logic_vector(4 downto 0);
		TagIn			: in std_logic_vector(4 downto 0);
		PCIn			: in std_logic_vector(31 downto 0);
		ExceptionIn		: in std_logic;
		CDBQ			: in std_logic_vector(4 downto 0);
		CDBV			: in std_logic_vector(31 downto 0);		
		WrEn			: in std_logic;
		GlobalWrEn		: in std_logic;
		Clear			: in std_logic;
		Clk				: in std_logic;
		Rst				: in std_logic;
		InstrTypeOut	: out std_logic_vector(1 downto 0);
		DestinationOut	: out std_logic_vector(4 downto 0);
		TagOut			: out std_logic_vector(4 downto 0);
		ValueOut		: out std_logic_vector(31 downto 0);
		PCOut			: out std_logic_vector(31 downto 0);
		ReadyOut		: out std_logic;
		ExceptionOut	: out std_logic;
		NewestOut		: out std_logic);
	end component;

	component Counter4 Port(
		Enable	: in std_logic;
		DataIn	: in std_logic_vector(3 downto 0);
		Load	: in std_logic;
		Clk		: in std_logic;
		Rst		: in std_logic;
		Output	: out std_logic_vector(0 to 3));
	end component;

	component CompareModuleNonZero is
		Port ( In0 : in  STD_LOGIC_VECTOR (4 downto 0);
		       In1 : in  STD_LOGIC_VECTOR (4 downto 0);
		       DOUT : out  STD_LOGIC);
	end component;

	component CompareModule is
		Port ( In0 : in  STD_LOGIC_VECTOR (4 downto 0);
		       In1 : in  STD_LOGIC_VECTOR (4 downto 0);
		       DOUT : out  STD_LOGIC);
	end component;

	component Demux1to16 Port(
		input 	: in  STD_LOGIC;
		output 	: out STD_LOGIC_VECTOR (15 downto 0);
		control : in  STD_LOGIC_VECTOR (3 downto 0));
	end component;

	component ReadPort Port(
		ReadAddr 		: in STD_LOGIC_VECTOR (4 downto 0);
		DestinationsIn	: in Bus16x5;
		ValuesIn		: in Bus16;
		TagsIn			: in Bus16x5;
		Newest			: in STD_LOGIC_VECTOR(15 downto 0);
		Available 		: out STD_LOGIC;
		Value			: out STD_LOGIC_VECTOR (31 downto 0);
		Tag				: out STD_LOGIC_VECTOR(4 downto 0));
	end component;
	
	signal HeadEnable,HeadLoad  : std_logic;                             -- Head
	signal TailEnable,TailLoad 	: std_logic; 							 -- Tail

	signal HeadDataIn, TailDataIn, HeadOutput, TailOutput: std_logic_vector(3 downto 0);

	signal HeadRAW				: STD_LOGIC_VECTOR(77 downto 0);
	signal HeadInstructionType 	: STD_LOGIC_VECTOR(1 downto 0);
	signal HeadDestination 		: STD_LOGIC_VECTOR(4 downto 0);
	signal HeadTag 				: STD_LOGIC_VECTOR(4 downto 0);
	signal HeadValue 			: STD_LOGIC_VECTOR(31 downto 0);
	signal HeadPC 				: STD_LOGIC_VECTOR(31 downto 0);
	signal HeadReady 			: STD_LOGIC;
	signal HeadException 		: STD_LOGIC;

	signal WrEnSignal, ReadyOutSignal, ExceptionOutSignal, NewestOutSignal: std_logic_vector(15 downto 0);
	signal InstrTypeOutSignal: Bus16x2;
	signal DestinationOutSignal, TagOutSignal: Bus16x5;
	signal ValueOutSignal, PCOutSignal: Bus16;
	signal EVERYONE : Bus16x78;
	signal clear : STD_LOGIC_VECTOR (15 downto 0);
	signal HeadClear : STD_LOGIC;

	signal full, empty: std_logic;
begin
	ReorderBufferBlockGenerator:
	for i in 0 to 15 generate
		ReorderBufferBlock_i: ReorderBufferBlock port map(
			InstrTypeIn		=> InstrTypeIn,
			DestinationIn	=> DestinationIn,
			TagIn			=> TagIn,
			PCIn			=> PCIn,
			ExceptionIn		=> ExceptionIn,
			CDBQ			=> CDBQ,
			CDBV			=> CDBV,
			WrEn			=> WrEnSignal(i),
			GlobalWrEn		=> WrEn,
			Clear 			=> clear(i) OR HeadException, -- clear everything when exception
			Clk				=> Clk,
			Rst				=> Rst,
			InstrTypeOut	=> InstrTypeOutSignal(i),
			DestinationOut	=> DestinationOutSignal(i),
			TagOut			=> TagOutSignal(i),
			ValueOut		=> ValueOutSignal(i),
			PCOut			=> PCOutSignal(i),
			ReadyOut		=> ReadyOutSignal(i),
			ExceptionOut	=> ExceptionOutSignal(i),
			NewestOut		=> NewestOutSignal(i));
		EVERYONE(i) <= InstrTypeOutSignal(i) & DestinationOutSignal(i) & TagOutSignal(i) & ValueOutSignal(i) & PCOutSignal(i) & ReadyOutSignal(i) & ExceptionOutSignal(i);
	end generate;

	emptyComparator	: CompareModule port map(In0=>'0' & HeadOutput,In1=>'0' & TailOutput,DOUT=>empty);
	fullComparator	: CompareModule port map(In0=>'0' & HeadOutput,In1=>'0' & (TailOutput+1),DOUT=>full);
	FullOut <= full ;

	Head: Counter4 port map (
		Enable	=> HeadEnable,
		DataIn	=> HeadDataIn,
		Load	=> HeadLoad,
		Clk		=> Clk,
		Rst		=> Rst,
		Output	=> HeadOutput);

	HeadLoad 	<= '0';
	HeadDataIn 	<= "0000";
	HeadEnable 	<= (NOT Empty) AND (NOT HeadException) AND (HeadReady);

	Tail: Counter4 port map(
		Enable	=> TailEnable,
		DataIn	=> TailDataIn,
		Load	=> TailLoad,
		Clk		=> Clk,
		Rst		=> Rst,
		Output	=> TailOutput);

	TailEnable 	<= WrEn AND(NOT full);
	TailLoad 	<= HeadException;
	TailDataIn 	<= HeadOutput;

	HeadMux : Mux16x78 Port Map (
		Input 	=> EVERYONE,
		Sel 	=> HeadOutput,
		Output 	=> HeadRAW);

	-- Unpack Mux

	HeadInstructionType <= HeadRAW(77 downto 76);
	HeadDestination 	<= HeadRAW(75 downto 71);
	HeadTag 			<= HeadRAW(70 downto 66);
	HeadValue 			<= HeadRAW(65 downto 34);
	HeadPC 				<= HeadRAW(33 downto 2);
	HeadReady 			<= HeadRAW(1);
	HeadException 		<= HeadRAW(0);

	InstrTypeOut <= HeadInstructionType;
	PCOut 		 <= HeadPC;
	Exc  		 <= HeadException;
	--RF Writing Logic
	RFWrEn 		<= HeadEnable ;
	RFAddr 		<= HeadDestination;
	RFWrData 	<= HeadValue;

	-- Demux Clear And WrEn For
	WrEnDemux : Demux1to16 Port Map (
		input 	=> WrEn,
	  	output 	=> WrEnSignal,
	  	control => TailOutput);

	ClearDemux : Demux1to16 Port Map (
		input 	=> HeadClear,
	  	output 	=> Clear,
	  	control => HeadOutput);

	HeadClear <= HeadEnable ; --clear when moving head

	ReadPort1: ReadPort Port map(      
		ReadAddr 		=> ReadAddr1,
		DestinationsIn	=> DestinationOutSignal,
		ValuesIn		=> ValueOutSignal,
		TagsIn			=> TagOutSignal,
		Newest			=> NewestOutSignal,
		Available 		=> Available1,
		Value 			=> DataOut1,
		Tag				=> TagOut1);
	ReadPort2: ReadPort Port map(
		ReadAddr 		=> ReadAddr2,
		DestinationsIn	=> DestinationOutSignal,
		ValuesIn		=> ValueOutSignal,
		TagsIn			=> TagOutSignal,
		Newest			=> NewestOutSignal,
		Available 		=> Available2,
		Value			=> DataOut2,
		Tag				=> TagOut2);
end Structural;