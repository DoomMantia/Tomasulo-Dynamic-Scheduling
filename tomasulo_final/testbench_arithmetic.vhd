
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
 
ENTITY testbench_arithmetic IS
END testbench_arithmetic;
 
ARCHITECTURE behavior OF testbench_arithmetic IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Arithmetic
    PORT(
         RST : IN  std_logic;
         CLK : IN  std_logic;
         Issue : IN  std_logic;
         Op : IN  std_logic_vector(1 downto 0);
         Vj : IN  std_logic_vector(31 downto 0);
         Vk : IN  std_logic_vector(31 downto 0);
         Qj : IN  std_logic_vector(4 downto 0);
         Qk : IN  std_logic_vector(4 downto 0);
         CDBV : IN  std_logic_vector(31 downto 0);
         CDBQ : IN  std_logic_vector(4 downto 0);
         Grant : IN  std_logic;
         Available : OUT  std_logic_vector(2 downto 0);
         VOut : OUT  std_logic_vector(31 downto 0);
         QOut : OUT  std_logic_vector(4 downto 0);
         RequestOut : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal RST : std_logic := '0';
   signal CLK : std_logic := '0';
   signal Issue : std_logic := '0';
   signal Op : std_logic_vector(1 downto 0) := (others => '0');
   signal Vj : std_logic_vector(31 downto 0) := (others => '0');
   signal Vk : std_logic_vector(31 downto 0) := (others => '0');
   signal Qj : std_logic_vector(4 downto 0) := (others => '0');
   signal Qk : std_logic_vector(4 downto 0) := (others => '0');
   signal CDBV : std_logic_vector(31 downto 0) := (others => '0');
   signal CDBQ : std_logic_vector(4 downto 0) := (others => '0');
   signal Grant : std_logic := '0';

 	--Outputs
   signal Available : std_logic_vector(2 downto 0);
   signal VOut : std_logic_vector(31 downto 0);
   signal QOut : std_logic_vector(4 downto 0);
   signal RequestOut : std_logic;

   -- Clock period definitions
    constant TbPeriod : time := 1000 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Arithmetic PORT MAP (
          RST => RST,
          CLK => CLK,
          Issue => Issue,
          Op => Op,
          Vj => Vj,
          Vk => Vk,
          Qj => Qj,
          Qk => Qk,
          CDBV => CDBV,
          CDBQ => CDBQ,
          Grant => Grant,
          Available => Available,
          VOut => VOut,
          QOut => QOut,
          RequestOut => RequestOut
        );

-- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that CLK is really your main clock signal
    CLK <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        Issue <= '0';
        Op <= (others => '0');
        Vj <= (others => '0');
        Vk <= (others => '0');
        Qj <= (others => '0');
        Qk <= (others => '0');
        CDBV <= (others => '0');
        CDBQ <= (others => '0');
        Grant <= '0';

        -- Reset generation
        -- EDIT: Check that RST is really your reset signal
        RST <= '1';
        wait for 5 * TbPeriod;
        RST <= '0';
        wait for TbPeriod;

        -- EDIT Add stimuli here
        Op <= "00";
        Vj <= "00000000000000000000000000100000";
        Vk <= "00000000000000000000000000001011";
        Qj <= "00000";
        Qk <= "00010";

        wait for TbPeriod;
        Issue <= '1';
        wait for TbPeriod;
        Issue <= '0';
        wait for TbPeriod;

        CDBV <= "10000000000000000000000000000000";
        CDBQ <= "00010";

        wait for 4*TbPeriod;

        Grant <= '1';
        wait for TbPeriod;
        Grant <= '0';
        wait for 100 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
		  wait;
		  end process;

END;
