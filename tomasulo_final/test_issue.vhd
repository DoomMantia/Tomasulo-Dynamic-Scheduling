
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY test_issue IS
END test_issue;
 
ARCHITECTURE behavior OF test_issue IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT IssueUnit
    PORT(
         IssueIn : IN  std_logic;
         FUType : IN  std_logic_vector(1 downto 0);
         Fop : IN  std_logic_vector(1 downto 0);
         Ri : IN  std_logic_vector(4 downto 0);
         Rj : IN  std_logic_vector(4 downto 0);
         Rk : IN  std_logic_vector(4 downto 0);
         RFReadAddr1 : OUT  std_logic_vector(4 downto 0);
         RFReadAddr2 : OUT  std_logic_vector(4 downto 0);
         RFTag : OUT  std_logic_vector(4 downto 0);
         RFAddrW : OUT  std_logic_vector(4 downto 0);
         RFWrEn : OUT  std_logic;
         Accepted : OUT  std_logic;
         OpOut : OUT  std_logic_vector(1 downto 0);
         ArithmeticAvailable : IN  std_logic_vector(2 downto 0);
         ArithmeticIssue : OUT  std_logic;
         LogicalAvailable : IN  std_logic_vector(2 downto 0);
         LogicalIssue : OUT  std_logic;
         BufferAvailable : IN  std_logic_vector(2 downto 0);
         BufferIssue : OUT  std_logic;
         Clk : IN  std_logic;
         Rst : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal IssueIn : std_logic := '0';
   signal FUType : std_logic_vector(1 downto 0) := (others => '0');
   signal Fop : std_logic_vector(1 downto 0) := (others => '0');
   signal Ri : std_logic_vector(4 downto 0) := (others => '0');
   signal Rj : std_logic_vector(4 downto 0) := (others => '0');
   signal Rk : std_logic_vector(4 downto 0) := (others => '0');
   signal ArithmeticAvailable : std_logic_vector(2 downto 0) := (others => '0');
   signal LogicalAvailable : std_logic_vector(2 downto 0) := (others => '0');
   signal BufferAvailable : std_logic_vector(2 downto 0) := (others => '0');
   signal Clk : std_logic := '0';
   signal Rst : std_logic := '0';

 	--Outputs
   signal RFReadAddr1 : std_logic_vector(4 downto 0);
   signal RFReadAddr2 : std_logic_vector(4 downto 0);
   signal RFTag : std_logic_vector(4 downto 0);
   signal RFAddrW : std_logic_vector(4 downto 0);
   signal RFWrEn : std_logic;
   signal Accepted : std_logic;
   signal OpOut : std_logic_vector(1 downto 0);
   signal ArithmeticIssue : std_logic;
   signal LogicalIssue : std_logic;
   signal BufferIssue : std_logic;

    constant TbPeriod : time := 10 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: IssueUnit PORT MAP (
          IssueIn => IssueIn,
          FUType => FUType,
          Fop => Fop,
          Ri => Ri,
          Rj => Rj,
          Rk => Rk,
          RFReadAddr1 => RFReadAddr1,
          RFReadAddr2 => RFReadAddr2,
          RFTag => RFTag,
          RFAddrW => RFAddrW,
          RFWrEn => RFWrEn,
          Accepted => Accepted,
          OpOut => OpOut,
          ArithmeticAvailable => ArithmeticAvailable,
          ArithmeticIssue => ArithmeticIssue,
          LogicalAvailable => LogicalAvailable,
          LogicalIssue => LogicalIssue,
          BufferAvailable => BufferAvailable,
          BufferIssue => BufferIssue,
          Clk => Clk,
          Rst => Rst
        );

 -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that Clk is really your main clock signal
    Clk <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        IssueIn <= '0';
        FUType <= (others => '0');
        Fop <= (others => '0');
        Ri <= (others => '0');
        Rj <= (others => '0');
        Rk <= (others => '0');
        ArithmeticAvailable <= (others => '0');
        LogicalAvailable <= (others => '0');

        -- Reset generation
        -- EDIT: Check that Rst is really your reset signal
        Rst <= '1';
        wait for 50 ns;
        Rst <= '0';
        wait for 50 ns;

        -- EDIT Add stimuli here
		IssueIn<='1';
		FUType<="00";
		Fop<="00";
		Ri<="00001";
		Rj<="00010";
		Rk<="00011";
		ArithmeticAvailable<="001";
		LogicalAvailable<="001";
		wait for 5*TbPeriod;
		
		IssueIn<='1';
		FUType<="00";
		Fop<="01";
		Ri<="00001";
		Rj<="00010";
		Rk<="00011";
		ArithmeticAvailable<="001";
		LogicalAvailable<="001";
		wait for 5*TbPeriod;
		
		IssueIn<='1';
		FUType<="01";
		Fop<="00";
		Ri<="00001";
		Rj<="00010";
		Rk<="00011";
		ArithmeticAvailable<="001";
		LogicalAvailable<="001";
		wait for 5*TbPeriod;
		
		IssueIn<='1';
		FUType<="01";
		Fop<="01";
		Ri<="00001";
		Rj<="00010";
		Rk<="00011";
		ArithmeticAvailable<="001";
		LogicalAvailable<="001";
		wait for 5*TbPeriod;
		
		IssueIn<='0';
		wait for 10*TbPeriod;
        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
      wait;
   end process;

END;
