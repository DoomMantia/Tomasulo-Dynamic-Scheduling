library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ArithmeticFunctionalUnit is
    Port ( Clk : in STD_LOGIC;
           En : in STD_LOGIC;
           Rst : in STD_LOGIC;
           Grant : in STD_LOGIC;
           Vj : in STD_LOGIC_VECTOR (31 downto 0);
           Vk : in STD_LOGIC_VECTOR (31 downto 0);
           Op : in STD_LOGIC_VECTOR (1 downto 0);
           Tag : in STD_LOGIC_VECTOR (4 downto 0);
           RequestOut : out STD_LOGIC;
           BusyOut : out STD_LOGIC;
           ResultOut : out STD_LOGIC_VECTOR (31 downto 0);
           TagOut : out STD_LOGIC_VECTOR (4 downto 0));
end ArithmeticFunctionalUnit;

architecture Behavioral of ArithmeticFunctionalUnit is

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
component ArithmeticUnit is
    Port ( Vj : in STD_LOGIC_VECTOR (31 downto 0);
           Vk : in STD_LOGIC_VECTOR (31 downto 0);
           Op : in STD_LOGIC_VECTOR (1 downto 0);
           DataOut : out STD_LOGIC_VECTOR (31 downto 0));
end component;

--Register Signals

Signal DataReg0Input : STD_LOGIC_VECTOR (31 downto 0);
Signal DataReg1Input : STD_LOGIC_VECTOR (31 downto 0);
Signal DataReg2Input : STD_LOGIC_VECTOR (31 downto 0);
Signal TagReg0Input : STD_LOGIC_VECTOR (4 downto 0);
Signal TagReg1Input : STD_LOGIC_VECTOR (4 downto 0);
Signal TagReg2Input : STD_LOGIC_VECTOR (4 downto 0);

Signal Reg0En : STD_LOGIC;
Signal Reg1En : STD_LOGIC;
Signal Reg2En : STD_LOGIC;

Signal Reg0Nop : STD_LOGIC;
Signal Reg1Nop : STD_LOGIC;

Signal MaskerDataIn : STD_LOGIC_VECTOR (31 downto 0);
Signal MaskerTagIn : STD_LOGIC_VECTOR (4 downto 0);

begin

--Simulating pipelined FU with 3x2 registers
--1 PipelineReg = 1 DataReg + 1 TagReg

DataReg0 : Register32 Port Map (
		   DataIn =>DataReg0Input,
           WrEn =>Reg0En,
           Clk =>CLK,
           DataOut =>DataReg1Input,
           Rst =>RST);

DataReg1 : Register32 Port Map (
		   DataIn =>DataReg1Input,
           WrEn =>Reg1En,
           Clk =>CLK,
           DataOut =>DataReg2Input,
           Rst =>RST);

DataReg2 : Register32 Port Map (
		   DataIn =>DataReg2Input,
           WrEn =>Reg2En,
           Clk =>CLK,
           DataOut =>ResultOut,
           Rst =>RST);

TagReg0 : Register5 Port Map ( 
		   DataIn =>TagReg0Input,
           WrEn =>Reg0En,
           Clk =>CLK,
           DataOut =>TagReg1Input,
           Rst =>RST);

TagReg1 : Register5 Port Map ( 
		   DataIn =>TagReg1Input,
           WrEn =>Reg1En,
           Clk =>CLK,
           DataOut =>TagReg2Input,
           Rst =>RST);

TagReg2 : Register5 Port Map ( 
		   DataIn =>TagReg2Input,
           WrEn =>Reg2En,
           Clk =>CLK,
           DataOut =>TagOut,
           Rst =>RST);

-- Functional Units
AU : ArithmeticUnit Port Map (
		   Vj => Vj,
           Vk => Vk,
           Op => Op,
           DataOut => MaskerDataIn);

-- Input Masker

MaskerTagIn <= Tag ;
with En select
	DataReg0Input <= MaskerDataIn when '1',
					 std_logic_vector(to_unsigned(0,32)) when others;

with En select
	TagReg0Input <= MaskerTagIn when '1',
					 std_logic_vector(to_unsigned(0,5)) when others;

--Register NOPs
-- no need for register 2 NOP

with TagReg1Input select
	Reg0Nop		<= '1' when "00000",
				   '0' when others;

with TagReg2Input select
	Reg1Nop		<= '1' when "00000",
				   '0' when others;

--  Register Enablers

Reg0En <= Grant OR Reg1Nop OR Reg0Nop ;
Reg1En <= Grant OR Reg1Nop ;
Reg2En <= Grant ;

-- Request Signal

RequestOut <= NOT Reg1Nop ;

-- Busy Signal

BusyOut <= (Reg0Nop NOR Reg1Nop) AND (NOT Grant);

end Behavioral;
