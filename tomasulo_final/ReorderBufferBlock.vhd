library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
entity ReorderBufferBlock is
	Port (InstrTypeIn: in std_logic_vector(1 downto 0);
		DestinationIn: in std_logic_vector(4 downto 0);
		TagIn: in std_logic_vector(4 downto 0);
		PCIn: in std_logic_vector(31 downto 0);
		ExceptionIn: in std_logic;
		CDBQ: in std_logic_vector(4 downto 0);
		CDBV: in std_logic_vector(31 downto 0);		
		WrEn: in std_logic;
		GlobalWrEn: in std_logic;
		Clear: in std_logic;
		Clk: in std_logic;
		Rst: in std_logic;
		InstrTypeOut: out std_logic_vector(1 downto 0);
		DestinationOut: out std_logic_vector(4 downto 0);
		TagOut: out std_logic_vector(4 downto 0);
		ValueOut: out std_logic_vector(31 downto 0);
		PCOut: out std_logic_vector(31 downto 0);
		ReadyOut: out std_logic;
		ExceptionOut: out std_logic;
		NewestOut: out std_logic
		);
end ReorderBufferBlock;
architecture Structural of ReorderBufferBlock is
	component Register32 is
		Port ( DataIn : in STD_LOGIC_VECTOR (31 downto 0);
		       WrEn : in STD_LOGIC;
		       Clk : in STD_LOGIC;
		       DataOut : out STD_LOGIC_VECTOR (31 downto 0);
		       Rst : in STD_LOGIC);
	      end component;
	      
	      component Register5 is
		Port ( DataIn : in STD_LOGIC_VECTOR (4 downto 0);
		       WrEn : in STD_LOGIC;
		       Rst : in STD_LOGIC;
		       Clk : in STD_LOGIC;
		       DataOut : out STD_LOGIC_VECTOR (4 downto 0));
	      end component;
	      
	      component Register2 is
		Port ( DataIn : in STD_LOGIC_VECTOR (1 downto 0);
		       WrEn : in STD_LOGIC;
		       Rst : in STD_LOGIC;
		       Clk : in STD_LOGIC;
		       DataOut : out STD_LOGIC_VECTOR (1 downto 0));
	      end component;
	      
	      component Register1 is
		Port ( DataIn : in STD_LOGIC;
		       WrEn : in STD_LOGIC;
		       Rst : in STD_LOGIC;
		       Clk : in STD_LOGIC;
		       DataOut : out STD_LOGIC);
	      end component;

	      component CompareModuleNonZero is
		Port ( In0 : in  STD_LOGIC_VECTOR (4 downto 0);
		       In1 : in  STD_LOGIC_VECTOR (4 downto 0);
		       DOUT : out  STD_LOGIC);
	      end component;

	signal ComparatorOut: std_logic;
	signal Comparator2Out: std_logic;
	signal DstComparatorOut: std_logic;
	signal ValueWrite: std_logic;
	signal intReadyOut: std_logic;
	signal tagOutSignal: std_logic_vector(4 downto 0);
	signal tagInSignal: std_logic_vector(4 downto 0);
	signal intDestinationOut: std_logic_vector(4 downto 0);

begin
	InstrTypeREG : Register2 Port Map (
							DataIn =>InstrTypeIn,
							WrEn =>WrEn,
							Clk =>Clk,
							DataOut =>InstrTypeOut,
							Rst =>Rst);

	DestinationREG : Register5 Port Map (
								DataIn =>DestinationIn,
								WrEn =>WrEn,
								Clk =>Clk,
								DataOut =>intDestinationOut,
								Rst =>Rst);

	TagREG : Register5 Port Map ( 
						DataIn =>TagInSignal,
						WrEn =>WrEn Or ValueWrite,
						Clk =>Clk,
						DataOut =>tagOutSignal,
						Rst =>Rst);

	with ValueWrite select
	TagInSignal <= TagIn   when '0',
				   "00000" when others;


	TagOut<=tagOutSignal;

	comparator: CompareModuleNonZero port map(
			In0		=>	CDBQ,
			In1		=>	tagOutSignal,
			DOUT	=>	ComparatorOut);

	ValueREG : Register32 Port Map (
							DataIn =>CDBV,
							WrEn =>ValueWrite,
							Clk =>Clk,
							DataOut =>ValueOut,
							Rst =>Rst);

	ReadyOut <= intReadyOut ;

	ValueWrite <= ComparatorOut AND (NOT intReadyOut);

	PCREG : Register32 Port Map ( DataIn =>PCIn,
						WrEn =>WrEn,
						Clk =>Clk,
						DataOut =>PCOut,
						Rst =>Rst);

	ReadyREG : Register1 Port Map (
							DataIn => Clear NOR WrEn,
							WrEn => ValueWrite OR WrEn Or Clear,
							Clk => Clk,
							DataOut =>intReadyOut,
							Rst =>Rst);
	
	ExceptionREG : Register1 Port Map (
								DataIn => ExceptionIn And (NOT Clear),
								WrEn =>WrEn OR Clear ,--OR ExceptionIn,
								Clk =>Clk,
								DataOut =>ExceptionOut,
								Rst =>Rst);

	DstComparator: CompareModuleNonZero port map(In0=>intDestinationOut,In1=>DestinationIn,DOUT=>DstComparatorOut);

	DestinationOut <= intDestinationOut;

	NewestREG : Register1 Port Map (
						DataIn => WrEn,
						WrEn =>(DstComparatorOut and GlobalWrEn) or WrEn,
						Clk =>Clk,
						DataOut =>NewestOut,
						Rst =>Rst);

end Structural;