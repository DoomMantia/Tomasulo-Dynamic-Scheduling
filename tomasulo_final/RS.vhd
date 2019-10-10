-- Authors:   Tzanis Fotakis
--            Apostolos Vailakis


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity RS is --TODO: USE Ex AND 1b Register to Stop double executions
    Port ( WrEn : in STD_LOGIC;
           Op : in STD_LOGIC_VECTOR (1 downto 0);       -- Operation input
           Vj : in STD_LOGIC_VECTOR (31 downto 0);      -- Vj Input
           Vk : in STD_LOGIC_VECTOR (31 downto 0);      -- Vk Input
           Qj : in STD_LOGIC_VECTOR (4 downto 0);       -- Qj Input
           Qk : in STD_LOGIC_VECTOR (4 downto 0);       -- Qk Input
           ID : in STD_LOGIC_VECTOR (4 downto 0);       -- RS ID
           Ex : in STD_LOGIC ;                          -- RS Executed
           OpOut : out STD_LOGIC_VECTOR (1 downto 0);   -- Operation Output
           VjOut : out STD_LOGIC_VECTOR (31 downto 0);  -- Vj Output 
           VkOut : out STD_LOGIC_VECTOR (31 downto 0);  -- Vk Output
           ReadyOut : out STD_LOGIC;                    -- Ready Output
           CDBQ : in STD_LOGIC_VECTOR (4 downto 0);     -- CDB.Q
           CDBV : in STD_LOGIC_VECTOR (31 downto 0);    -- CDB.V
           BusyOut : out STD_LOGIC;                     -- Busy
           RST : in STD_LOGIC;                          -- RESET
           CLK : in STD_LOGIC);                         -- Clock
end RS;

architecture Behavioral of RS is

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

SIGNAL QjInput : STD_LOGIC_VECTOR (4 downto 0);
SIGNAL QkInput : STD_LOGIC_VECTOR (4 downto 0);

SIGNAL VjInput : STD_LOGIC_VECTOR (31 downto 0);
SIGNAL VkInput : STD_LOGIC_VECTOR (31 downto 0);

SIGNAL QjInternal : STD_LOGIC_VECTOR (4 downto 0);
SIGNAL QkInternal : STD_LOGIC_VECTOR (4 downto 0);

SIGNAL Qj0 : STD_LOGIC;
SIGNAL Qk0 : STD_LOGIC;

SIGNAL VjWrEN : STD_LOGIC;
SIGNAL VkWrEN : STD_LOGIC;

SIGNAL QjWrEN : STD_LOGIC;
SIGNAL QkWrEN : STD_LOGIC;

SIGNAL Comp1Out : STD_LOGIC;
SIGNAL Comp2Out : STD_LOGIC;
SIGNAL Comp3Out : STD_LOGIC;
SIGNAL Comp4Out : STD_LOGIC;
SIGNAL Comp5Out : STD_LOGIC;

Signal CDBjMul : STD_LOGIC;
Signal CDBkMul : STD_LOGIC;

SIGNAL BusyRegIn : STD_LOGIC;
SIGNAL BusyRegWrEn : STD_LOGIC;
SIGNAL IntBusyOut : STD_LOGIC;
SIGNAL BusyRst : STD_LOGIC;

-- Register Used Only to Disable Ready Signal After Excecution
SIGNAL rEnOut : STD_LOGIC;
SIGNAL rEnWren : STD_LOGIC;

SIGNAL MyDataOnCDB : STD_LOGIC ;


begin
-- Busy Register
BREG : Register1 Port Map (
         DataIn =>BusyRegIn,
         WrEn =>BusyRegWrEn,
         Clk =>CLK,
         DataOut =>IntBusyOut,
         Rst =>BusyRst);

-- Ready Register
RREG : Register1 Port Map (
         DataIn =>Wren,
         WrEn =>rEnWren,
         Clk =>CLK,
         DataOut =>rEnOut,
         Rst =>RST);

-- V Registers

VjREG : Register32 Port Map (
         DataIn =>VjInput,
         WrEn =>VjWrEN,
         Clk =>CLK,
         DataOut =>VjOut,
         Rst =>RST);

VkREG : Register32 Port Map ( 
         DataIn =>VkInput,
         WrEn =>VkWrEN,
         Clk =>CLK,
         DataOut =>VkOut,
         Rst =>RST);

-- Q Registers

QjREG : Register5 Port Map ( 
         DataIn =>QjInput,
         WrEn =>QjWrEN,
         Clk =>CLK,
         DataOut =>QjInternal,
         Rst =>RST);

QkREG : Register5 Port Map ( 
         DataIn =>QkInput,
         WrEn =>QkWrEN,
         Clk =>CLK,
         DataOut =>QkInternal,
         Rst =>RST);
-- OP Register

OpREG : Register2 Port Map ( 
         DataIn =>Op,
         WrEn =>WrEn,
         Clk =>CLK,
         DataOut =>OpOut,
         Rst =>RST);
-- Comparator

-- CDBQ == Qj
Comp1 : CompareModuleNonZero Port Map( 
         In0 =>CDBQ,
         In1 =>QjInternal,
         DOUT =>Comp1Out );
-- CDBQ == Qk
Comp2 : CompareModuleNonZero Port Map( 
         In0 =>CDBQ,
         In1 =>QkInternal,
         DOUT =>Comp2Out );
-- CDBQ == 00000
Comp3 : CompareModuleNonZero Port Map( 
         In0 =>CDBQ,
         In1 =>"00000",
         DOUT =>Comp3Out );
-- CDBQ == pre-Qj
Comp4 : CompareModuleNonZero Port Map( 
         In0 =>CDBQ,
         In1 =>Qj,
         DOUT =>Comp4Out );
-- CDBQ == pre-Qk
Comp5 : CompareModuleNonZero Port Map( 
         In0 =>CDBQ,
         In1 =>Qk,
         DOUT =>Comp5Out );

-- CDBQ == ID 
Comp6 : CompareModuleNonZero Port Map( 
         In0 =>CDBQ,
         In1 =>ID,
         DOUT =>MyDataOnCDB );


-- Busy Signal Register
BusyRst <= RST OR MyDataOnCDB ;  --Reset Busy When Data are exported from CDB
BusyRegWrEn <= WrEn ; --Busy = 1 when WrEn 
BusyRegIn <= WrEn ;   --Busy = 1 when WrEn
BusyOut <= IntBusyOut ;


-- Ready Signal (Ready to be excecuted)
with QjInternal select
	Qj0 <=      '0' when std_logic_vector(to_unsigned(0,5)),
				      '1' when others ;

with QkInternal select
	Qk0 <=      '0' when std_logic_vector(to_unsigned(0,5)),
				      '1' when others ;

ReadyOut <= (Qj0 NOR Qk0) AND rEnOut ;

rEnWren <= WrEn OR Ex ;

-- Multiplex Q Inputs

with CDBjMul select 
  QjInput <= Qj when '0',
             "00000" when others;

with CDBkMul select 
  QkInput <= Qk when '0',
             "00000" when others;

-- Multiplex V Inputs
with CDBjMul select
	VjInput <=      Vj when '0',
					        CDBV when others ;

with CDBkMul select
	VkInput <=      Vk when '0',
					        CDBV when others ;

-- Registers WrEn ORing

VjWrEN <= WrEn OR (Comp1Out AND (NOT Comp3Out)) ;
VkWrEN <= WrEn OR (Comp2Out AND (NOT Comp3Out)) ;

QjWrEN <= WrEn OR (Comp1Out AND (NOT Comp3Out)) ;
QkWrEN <= WrEn OR (Comp2Out AND (NOT Comp3Out)) ;


--Input Multiplexitng

CDBjMul <= (Comp4Out AND WrEn) OR Comp1Out ;
CDBkMul <= (Comp5Out AND WrEn) OR Comp2Out;

end Behavioral;