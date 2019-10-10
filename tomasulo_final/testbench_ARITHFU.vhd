
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY testbench_ARITHFU IS
END testbench_ARITHFU;
 
ARCHITECTURE behavior OF testbench_ARITHFU IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ArithmeticFU
    PORT(
         Clk : IN  std_logic;
         En : IN  std_logic;
         Rst : IN  std_logic;
         Grant : IN  std_logic;
         Vj : IN  std_logic_vector(31 downto 0);
         Vk : IN  std_logic_vector(31 downto 0);
         Op : IN  std_logic_vector(1 downto 0);
         Tag : IN  std_logic_vector(4 downto 0);
         RequestOut : OUT  std_logic;
         BusyOut : OUT  std_logic;
         ResultOut : OUT  std_logic_vector(31 downto 0);
         TagOut : OUT  std_logic_vector(4 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal Clk : std_logic := '0';
   signal En : std_logic := '0';
   signal Rst : std_logic := '0';
   signal Grant : std_logic := '0';
   signal Vj : std_logic_vector(31 downto 0) := (others => '0');
   signal Vk : std_logic_vector(31 downto 0) := (others => '0');
   signal Op : std_logic_vector(1 downto 0) := (others => '0');
   signal Tag : std_logic_vector(4 downto 0) := (others => '0');

 	--Outputs
   signal RequestOut : std_logic;
   signal BusyOut : std_logic;
   signal ResultOut : std_logic_vector(31 downto 0);
   signal TagOut : std_logic_vector(4 downto 0);

	 constant TbPeriod : time := 1000 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ArithmeticFU PORT MAP (
          Clk => Clk,
          En => En,
          Rst => Rst,
          Grant => Grant,
          Vj => Vj,
          Vk => Vk,
          Op => Op,
          Tag => Tag,
          RequestOut => RequestOut,
          BusyOut => BusyOut,
          ResultOut => ResultOut,
          TagOut => TagOut
        );



    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that Clk is really your main clock signal
    Clk <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        En <= '0';
        Grant <= '0';
        Vj <= (others => '0');
        Vk <= (others => '0');
        Op <= (others => '0');
        Tag <= (others => '0');

        -- Reset generation
        -- EDIT: Check that Rst is really your reset signal
        Rst <= '1';
        wait for 5 * TbPeriod;
        Rst <= '0';
        wait for 5 * TbPeriod;

        -- EDIT Add stimuli here
        Vj <= "00000000000000000000000000000011" ;
        Vk <= "00000000000000000000000000000110" ;
        Op <= "00";
        Tag <= "00111";

        wait for TbPeriod;
        En <= '1';
        wait for TbPeriod;
        En <= '0';
        wait for TbPeriod;
        Grant <= '1';
        wait for TbPeriod;
        Grant <= '0';
        wait for 100 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
      wait;
   end process;

END;
