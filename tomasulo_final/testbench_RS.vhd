
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

 
ENTITY testbench_RS IS
END testbench_RS;
 
ARCHITECTURE behavior OF testbench_RS IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ReservationStation
    PORT(
         WrEn : IN  std_logic;
         Op : IN  std_logic_vector(1 downto 0);
         Vj : IN  std_logic_vector(31 downto 0);
         Vk : IN  std_logic_vector(31 downto 0);
         Qj : IN  std_logic_vector(4 downto 0);
         Qk : IN  std_logic_vector(4 downto 0);
         ID : IN  std_logic_vector(4 downto 0);
         Ex : IN  std_logic;
         OpOut : OUT  std_logic_vector(1 downto 0);
         VjOut : OUT  std_logic_vector(31 downto 0);
         VkOut : OUT  std_logic_vector(31 downto 0);
         ReadyOut : OUT  std_logic;
         CDBQ : IN  std_logic_vector(4 downto 0);
         CDBV : IN  std_logic_vector(31 downto 0);
         BusyOut : OUT  std_logic;
         RST : IN  std_logic;
         CLK : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal WrEn : std_logic := '0';
   signal Op : std_logic_vector(1 downto 0) := (others => '0');
   signal Vj : std_logic_vector(31 downto 0) := (others => '0');
   signal Vk : std_logic_vector(31 downto 0) := (others => '0');
   signal Qj : std_logic_vector(4 downto 0) := (others => '0');
   signal Qk : std_logic_vector(4 downto 0) := (others => '0');
   signal ID : std_logic_vector(4 downto 0) := (others => '0');
   signal Ex : std_logic := '0';
   signal CDBQ : std_logic_vector(4 downto 0) := (others => '0');
   signal CDBV : std_logic_vector(31 downto 0) := (others => '0');
   signal RST : std_logic := '0';
   signal CLK : std_logic := '0';

 	--Outputs
   signal OpOut : std_logic_vector(1 downto 0);
   signal VjOut : std_logic_vector(31 downto 0);
   signal VkOut : std_logic_vector(31 downto 0);
   signal ReadyOut : std_logic;
   signal BusyOut : std_logic;

    constant TbPeriod : time := 1000 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ReservationStation PORT MAP (
          WrEn => WrEn,
          Op => Op,
          Vj => Vj,
          Vk => Vk,
          Qj => Qj,
          Qk => Qk,
          ID => ID,
          Ex => Ex,
          OpOut => OpOut,
          VjOut => VjOut,
          VkOut => VkOut,
          ReadyOut => ReadyOut,
          CDBQ => CDBQ,
          CDBV => CDBV,
          BusyOut => BusyOut,
          RST => RST,
          CLK => CLK
        );


   -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that CLK is really your main clock signal
    CLK <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        WrEn <= '0';
        Op <= (others => '0');
        Vj <= (others => '0');
        Vk <= (others => '0');
        Qj <= (others => '0');
        Qk <= (others => '0');
        CDBQ <= (others => '0');
        CDBV <= (others => '0');
        ex <= '0';

        -- Reset generation
        -- EDIT: Check that RST is really your reset signal
        RST <= '1';
        wait for 100 ns;
        RST <= '0';
        wait for 100 ns;

        Vj <= "00000000000000000000000000000010";
        Vk <= "00000000000000000000000000000100";
        Qj <= "00010";
        Qk <= "00100";

        wait for  TbPeriod;
        WrEn <= '1' ;
        wait for  TbPeriod;
        WrEn <= '0' ;

        wait for  5* TbPeriod;

        -- CDB STIMULATION

        CDBV <= "00000000000000011000000000000010";
        CDBQ <= "00010";

        wait for  TbPeriod;

        CDBQ <= "00000";

        CDBV <= "00000000000000011000000011000010";
        CDBQ <= "00100";

        wait for  TbPeriod;

        CDBV <= "00000000000000000000000000000000";
        CDBQ <= "00000";

        wait for  2*TbPeriod;
        ex <= '1';
        wait for  TbPeriod;
        ex <= '0';

        -- EDIT Add stimuli here
        wait for 100 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';


      wait;
   end process;

END;
