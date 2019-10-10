
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
 
ENTITY test_CDB IS
END test_CDB;
 
ARCHITECTURE behavior OF test_CDB IS 
 
    COMPONENT CDB
    PORT(
         QArithmetic : IN  std_logic_vector(4 downto 0);
         VArithmetic : IN  std_logic_vector(31 downto 0);
         QLogical : IN  std_logic_vector(4 downto 0);
         VLogical : IN  std_logic_vector(31 downto 0);
         QBuffer : IN  std_logic_vector(4 downto 0);
         VBuffer : IN  std_logic_vector(31 downto 0);
         ArithmeticRequest : IN  std_logic;
         LogicalRequest : IN  std_logic;
         BufferRequest : IN  std_logic;
         Clk : IN  std_logic;
         Rst : IN  std_logic;
         Qout : OUT  std_logic_vector(4 downto 0);
         Vout : OUT  std_logic_vector(31 downto 0);
         GrantArithmetic : OUT  std_logic;
         GrantLogical : OUT  std_logic;
         GrantBuffer : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal QArithmetic : std_logic_vector(4 downto 0) := (others => '0');
   signal VArithmetic : std_logic_vector(31 downto 0) := (others => '0');
   signal QLogical : std_logic_vector(4 downto 0) := (others => '0');
   signal VLogical : std_logic_vector(31 downto 0) := (others => '0');
   signal QBuffer : std_logic_vector(4 downto 0) := (others => '0');
   signal VBuffer : std_logic_vector(31 downto 0) := (others => '0');
   signal ArithmeticRequest : std_logic := '0';
   signal LogicalRequest : std_logic := '0';
   signal BufferRequest : std_logic := '0';
   signal Clk : std_logic := '0';
   signal Rst : std_logic := '0';

 	--Outputs
   signal Qout : std_logic_vector(4 downto 0);
   signal Vout : std_logic_vector(31 downto 0);
   signal GrantArithmetic : std_logic;
   signal GrantLogical : std_logic;
   signal GrantBuffer : std_logic;

   -- Clock period definitions
   constant TbPeriod : time := 10 ns;
   signal TbClock : std_logic := '0';
   signal TbSimEnded : std_logic := '0';
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: CDB PORT MAP (
          QArithmetic => QArithmetic,
          VArithmetic => VArithmetic,
          QLogical => QLogical,
          VLogical => VLogical,
          QBuffer => QBuffer,
          VBuffer => VBuffer,
          ArithmeticRequest => ArithmeticRequest,
          LogicalRequest => LogicalRequest,
          BufferRequest => BufferRequest,
          Clk => Clk,
          Rst => Rst,
          Qout => Qout,
          Vout => Vout,
          GrantArithmetic => GrantArithmetic,
          GrantLogical => GrantLogical,
          GrantBuffer => GrantBuffer
        );

 -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

 -- EDIT: Check that Clk is really your main clock signal
    Clk <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        QArithmetic <= (others => '0');
        VArithmetic <= (others => '0');
        QLogical <= (others => '0');
        VLogical <= (others => '0');
        QBuffer <= (others => '0');
        VBuffer <= (others => '0');
        ArithmeticRequest <= '0';
        LogicalRequest <= '0';
        BufferRequest <= '0';

        -- Reset generation
        -- EDIT: Check that Rst is really your reset signal
        Rst <= '1';
        wait for 100 ns;
        Rst <= '0';
        wait for 100 ns;

        -- EDIT Add stimuli here
        QArithmetic <= "01001";
		VArithmetic <= std_logic_vector(to_unsigned(10,32));
		QLogical <= "01010";
		VLogical <= std_logic_vector(to_unsigned(20,32));
		QBuffer <= "01011";
		VBuffer <= std_logic_vector(to_unsigned(30,32));
		ArithmeticRequest <= '1';
		LogicalRequest <= '1';
		BufferRequest <= '1';
        wait for 100 ns;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
      wait;
   end process;

END;
