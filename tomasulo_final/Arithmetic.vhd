library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Arithmetic is
    Port ( RST : in STD_LOGIC;
           CLK : in STD_LOGIC;
           Issue : in STD_LOGIC;
           Op : in STD_LOGIC_VECTOR (1 downto 0);
           Vj : in STD_LOGIC_VECTOR (31 downto 0);
           Vk : in STD_LOGIC_VECTOR (31 downto 0);
           Qj : in STD_LOGIC_VECTOR (4 downto 0);
           Qk : in STD_LOGIC_VECTOR (4 downto 0);
           CDBV : in STD_LOGIC_VECTOR (31 downto 0);
           CDBQ : in STD_LOGIC_VECTOR (4 downto 0);
           Grant : in STD_LOGIC;
           Available : out STD_LOGIC_VECTOR(2 downto 0);
           VOut : out STD_LOGIC_VECTOR (31 downto 0);
           QOut : out STD_LOGIC_VECTOR (4 downto 0);
           RequestOut : out STD_LOGIC);
end Arithmetic;

architecture Behavioral of Arithmetic is

component ArithmeticFunctionalUnit is
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
end component;

component RS is 
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
end component;

component RSSelectArithmetic is
    Port ( Executable : in STD_LOGIC_VECTOR (2 downto 0);
           Clk : in STD_LOGIC;
           Rst : in STD_LOGIC;
           Tag : out STD_LOGIC_VECTOR (2 downto 0));
end component;

component Register2 is
    Port ( DataIn : in STD_LOGIC_VECTOR (1 downto 0);
           WrEn : in STD_LOGIC;
           Rst : in STD_LOGIC;
           Clk : in STD_LOGIC;
           DataOut : out STD_LOGIC_VECTOR (1 downto 0));
end component;

-- RS Signals --
  -- RS1
    SIGNAL RS1VjOut : STD_LOGIC_VECTOR (31 downto 0);
    SIGNAL RS1VkOut : STD_LOGIC_VECTOR (31 downto 0);
    SIGNAL RS1OpOut : STD_LOGIC_VECTOR (1 downto 0);
    SIGNAL RS1Ready : STD_LOGIC;
    SIGNAL RS1Busy  : STD_LOGIC;
    SIGNAL RS1Ex    : STD_LOGIC;
    SIGNAL RS1WrEn  : STD_LOGIC;

  -- RS2
    SIGNAL RS2VjOut : STD_LOGIC_VECTOR (31 downto 0);
    SIGNAL RS2VkOut : STD_LOGIC_VECTOR (31 downto 0);
    SIGNAL RS2OpOut : STD_LOGIC_VECTOR (1 downto 0);
    SIGNAL RS2Ready : STD_LOGIC;
    SIGNAL RS2Busy  : STD_LOGIC;
    SIGNAL RS2Ex    : STD_LOGIC;
    SIGNAL RS2WrEn  : STD_LOGIC;

  -- RS3
    SIGNAL RS3VjOut : STD_LOGIC_VECTOR (31 downto 0);
    SIGNAL RS3VkOut : STD_LOGIC_VECTOR (31 downto 0);
    SIGNAL RS3OpOut : STD_LOGIC_VECTOR (1 downto 0);
    SIGNAL RS3Ready : STD_LOGIC;
    SIGNAL RS3Busy  : STD_LOGIC;
    SIGNAL RS3Ex    : STD_LOGIC;
    SIGNAL RS3WrEn  : STD_LOGIC;

-- Arithmetic Unit Signals

  SIGNAL AUVj     : STD_LOGIC_VECTOR (31 downto 0);
  SIGNAL AUVk     : STD_LOGIC_VECTOR (31 downto 0);
  SIGNAL AUOp     : STD_LOGIC_VECTOR (1 downto 0);
  SIGNAL AUTag    : STD_LOGIC_VECTOR (4 downto 0);
  SIGNAL AUEn     : STD_LOGIC;
  SIGNAL AUBusy   : STD_LOGIC;

-- RSExSELECT Signals
  SIGNAL ExTAG : STD_LOGIC_VECTOR (2 downto 0);
  SIGNAL ExcecutionRS : STD_LOGIC_VECTOR (2 downto 0); -- Bit per RS

-- Available RS
  SIGNAL IntAvailable : STD_LOGIC_VECTOR (2 downto 0);

-- Gerenics
  --SIGNAL GenericAvailable : STD_LOGIC ;
  SIGNAL GenericExcecution : STD_LOGIC ;

  SIGNAL OpDelayOut : STD_LOGIC_VECTOR(1 downto 0);
begin

RSEXSELECT : RSSelectArithmetic Port Map( 
           Executable(0) => RS1Ready,
           Executable(1) => RS2Ready,
           Executable(2) => RS3Ready,
           Clk => CLK,
           Rst => RST,
           Tag => ExTAG);

OpDelay : Register2 Port Map (
         DataIn =>Op,
         WrEn =>'1',
         Clk =>CLK,
         DataOut =>OpDelayOut,
         Rst =>RST);

RS1 : RS Port Map( 
           WrEn => RS1WrEn,
           Op => Op,
           Vj => Vj,
           Vk => Vk,
           Qj => Qj,
           Qk => Qk,
           ID => "01001",
           Ex =>RS1Ex,
           OpOut => RS1OpOut,
           VjOut => RS1VjOut,
           VkOut => RS1VkOut,
           ReadyOut => RS1Ready,
           CDBQ => CDBQ,
           CDBV => CDBV,
           BusyOut => RS1Busy,
           RST => rst,
           CLK => clk);

RS2 : RS Port Map( 
           WrEn => RS2WrEn,
           Op => Op,
           Vj => Vj,
           Vk => Vk,
           Qj => Qj,
           Qk => Qk,
           ID => "01010",
           Ex =>RS2Ex,
           OpOut => RS2OpOut,
           VjOut => RS2VjOut,
           VkOut => RS2VkOut,
           ReadyOut => RS2Ready,
           CDBQ => CDBQ,
           CDBV => CDBV,
           BusyOut => RS2Busy,
           RST => rst,
           CLK => clk);    

RS3 : RS Port Map( 
           WrEn => RS3WrEn,
           Op => Op,
           Vj => Vj,
           Vk => Vk,
           Qj => Qj,
           Qk => Qk,
           ID => "01011",
           Ex =>RS3Ex,
           OpOut => RS3OpOut,
           VjOut => RS3VjOut,
           VkOut => RS3VkOut,
           ReadyOut => RS3Ready,
           CDBQ => CDBQ,
           CDBV => CDBV,
           BusyOut => RS3Busy,
           RST => rst,
           CLK => clk);    

AU : ArithmeticFunctionalUnit Port Map ( 
           Clk => clk,
           En => AUEn,
           Rst => RST,
           Grant => Grant,
           Vj => AUVj,
           Vk => AUVk,
           Op => AUOp,
           Tag => AUTag,
           RequestOut => RequestOut,
           BusyOut => AUBusy,
           ResultOut => VOut,
           TagOut => QOut);

--Select Available RS
IntAvailable(0) <= NOT RS1Busy ;
IntAvailable(1) <= RS1Busy AND (NOT RS2Busy);
IntAvailable(2) <= RS1Busy AND RS2Busy AND (NOT RS3Busy);

--Available <= IntAvailable ;
------------------------------------------I THINK I NEED THIS ?!?
with IntAvailable Select
Available <= "001" when "001",
             "010" when "010",
             "011" when "100",
             "000" when others ;

--Enable RS Writing
RS1WrEn <= IntAvailable(0) AND Issue ;
RS2WrEn <= IntAvailable(1) AND Issue ;
RS3WrEn <= IntAvailable(2) AND Issue ;

-- Setup AU TAG
AUTag <= "0" & GenericExcecution & ExTAG ;

--Select RS to excecute 
with ExTAG Select
  ExcecutionRS <= "001" when "001",
                  "010" when "010",
                  "100" when "011",
                  "000" when others;

with ExTAG Select
  AUVj <=         RS1VjOut when "001",
                  RS2VjOut when "010",
                  RS3VjOut when "011",
                  std_logic_vector(to_unsigned(0,32)) when others;

with ExTAG Select
  AUVk <=         RS1VkOut when "001",
                  RS2VkOut when "010",
                  RS3VkOut when "011",
                  std_logic_vector(to_unsigned(0,32)) when others;

with ExTAG Select
  AUOp <=         RS1OpOut when "001",
                  RS2OpOut when "010",
                  RS3OpOut when "011",
                  "00"     when others;                  

--Generics
GenericExcecution <= (ExTAG(0) OR ExTAG(1) OR ExTAG(2)) AND (NOT AUBusy) ;

--Excecute
AUEn <= GenericExcecution ;

RS1Ex <= GenericExcecution AND ExcecutionRS(0);
RS2Ex <= GenericExcecution AND ExcecutionRS(1);
RS3Ex <= GenericExcecution AND ExcecutionRS(2);

end Behavioral;
