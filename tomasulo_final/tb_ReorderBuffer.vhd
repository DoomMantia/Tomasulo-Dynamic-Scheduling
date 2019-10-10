library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_ReorderBuffer is
end tb_ReorderBuffer;

architecture tb of tb_ReorderBuffer is

    component ReorderBuffer
        port (InstrTypeIn   : in  std_logic_vector (1 downto 0);
              DestinationIn : in  std_logic_vector (4 downto 0);
              TagIn         : in  std_logic_vector (4 downto 0);
              PCIn          : in  std_logic_vector (31 downto 0);
              ExceptionIn   : in  std_logic;
              CDBQ          : in  std_logic_vector (4 downto 0);
              CDBV          : in  std_logic_vector (31 downto 0);
              WrEn          : in  std_logic;
              ReadAddr1     : in  std_logic_vector (4 downto 0);
              ReadAddr2     : in  std_logic_vector (4 downto 0);
              Clk           : in  std_logic;
              Rst           : in  std_logic;
              RFWrEn        : out std_logic;
              Exc           : out std_logic;
              RFAddr        : out std_logic_vector (4 downto 0);
              RFWrData      : out std_logic_vector (31 downto 0);
              InstrTypeOut  : out std_logic_vector (1 downto 0);
              PCOut         : out std_logic_vector (31 downto 0);
              FullOut       : out std_logic;
              DataOut1      : out std_logic_vector (31 downto 0);
              TagOut1       : out std_logic_vector (4 downto 0);
              Available1    : out std_logic;
              DataOut2      : out std_logic_vector (31 downto 0);
              TagOut2       : out std_logic_vector (4 downto 0);
              Available2    : out std_logic);
    end component;

    signal InstrTypeIn   : std_logic_vector (1 downto 0);
    signal DestinationIn : std_logic_vector (4 downto 0);
    signal TagIn         : std_logic_vector (4 downto 0);
    signal PCIn          : std_logic_vector (31 downto 0);
    signal ExceptionIn   : std_logic;
    signal CDBQ          : std_logic_vector (4 downto 0);
    signal CDBV          : std_logic_vector (31 downto 0);
    signal WrEn          : std_logic;
    signal ReadAddr1     : std_logic_vector (4 downto 0);
    signal ReadAddr2     : std_logic_vector (4 downto 0);
    signal Clk           : std_logic;
    signal Rst           : std_logic;
    signal RFWrEn        : std_logic;
    signal RFAddr        : std_logic_vector (4 downto 0);
    signal RFWrData      : std_logic_vector (31 downto 0);
    signal InstrTypeOut  : std_logic_vector (1 downto 0);
    signal PCOut         : std_logic_vector (31 downto 0);
    signal FullOut       : std_logic;
    signal DataOut1      : std_logic_vector (31 downto 0);
    signal TagOut1       : std_logic_vector (4 downto 0);
    signal Available1    : std_logic;
    signal DataOut2      : std_logic_vector (31 downto 0);
    signal TagOut2       : std_logic_vector (4 downto 0);
    signal Available2    : std_logic;
    signal Exc           : std_logic;

    signal Test          : std_logic;

    constant TbPeriod : time := 10 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '1';
    signal TbSimEnded : std_logic := '0';

begin
    dut : ReorderBuffer
    port map (InstrTypeIn   => InstrTypeIn,
              DestinationIn => DestinationIn,
              TagIn         => TagIn,
              PCIn          => PCIn,
              ExceptionIn   => ExceptionIn,
              CDBQ          => CDBQ,
              CDBV          => CDBV,
              WrEn          => WrEn,
              ReadAddr1     => ReadAddr1,
              ReadAddr2     => ReadAddr2,
              Clk           => Clk,
              Rst           => Rst,
              RFWrEn        => RFWrEn,
              Exc           => Exc,
              RFAddr        => RFAddr,
              RFWrData      => RFWrData,
              InstrTypeOut  => InstrTypeOut,
              PCOut         => PCOut,
              FullOut       => FullOut,
              DataOut1      => DataOut1,
              TagOut1       => TagOut1,
              Available1    => Available1,
              DataOut2      => DataOut2,
              TagOut2       => TagOut2,
              Available2    => Available2);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that Clk is really your main clock signal
    Clk <= TbClock;

    Test<= '1';

    stimuli : process
    begin

    InstrTypeIn <= (others => '0');
    DestinationIn <= (others => '0');
    TagIn <= (others => '0');
    PCIn <= (others => '0');
    ExceptionIn <= '0';
    CDBQ <= (others => '0');
    CDBV <= (others => '0');
    WrEn <= '0';
    ReadAddr1     <= "00011";
    ReadAddr2     <= "00100";

    Rst <= '1';
    wait for 20 ns;
    Rst <= '0';
    wait for 10 ns;

    if Test = '0' then -------------------------------------------Simulation 0
        --Set Instructions : 
        
        InstrTypeIn   <= "01";           --Instruction Type
        DestinationIn <= "00011";        --Destination
        TagIn         <= "01001";        --Tag
        PCIn          <= std_logic_vector(to_unsigned(4,32));
        ExceptionIn   <= '0';            --Exception
        WrEn          <= '1';

        wait for  3*TbPeriod ;

        InstrTypeIn   <= "01";           --Instruction Type
        DestinationIn <= "00100";        --Destination
        TagIn         <= "01010";        --Tag
        PCIn          <= std_logic_vector(to_unsigned(4,32));
        ExceptionIn   <= '0';            --Exception
        WrEn          <= '1';

        wait for 1*TbPeriod;

        InstrTypeIn   <= "01";           --Instruction Type
        DestinationIn <= "00011";        --Destination
        TagIn         <= "01001";        --Tag
        PCIn          <= std_logic_vector(to_unsigned(4,32));
        ExceptionIn   <= '0';            --Exception
        WrEn          <= '1';

        CDBQ          <= "01010";
        CDBV          <= std_logic_vector(to_unsigned(3,32));

        wait for 1*TbPeriod;

        CDBQ <= (others => '0');
        CDBV <= (others => '0');

        wait for  6*TbPeriod ;

        InstrTypeIn   <= "01";           --Instruction Type
        DestinationIn <= "00100";        --Destination
        TagIn         <= "01011";        --Tag
        PCIn          <= std_logic_vector(to_unsigned(4,32));
        ExceptionIn   <= '0';            --Exception
        WrEn          <= '1';

        wait for  1*TbPeriod ;

        InstrTypeIn   <= "01";           --Instruction Type
        DestinationIn <= "00011";        --Destination
        TagIn         <= "01001";        --Tag
        PCIn          <= std_logic_vector(to_unsigned(4,32));
        ExceptionIn   <= '0';            --Exception
        WrEn          <= '1';

        -- EDIT Add stimuli here
        wait for 100 * TbPeriod;
        -- Stop the clock and hence terminate the simulation
    else---------------------------------------------------------------------Simulation 1

        InstrTypeIn   <= "01";           --Instruction Type
        DestinationIn <= "00001";        --Destination
        TagIn         <= "01011";        --Tag
        PCIn          <= std_logic_vector(to_unsigned(4,32));
        WrEn          <= '1';

        wait for  1*TbPeriod ;

        InstrTypeIn   <= "01";           --Instruction Type
        DestinationIn <= "00010";        --Destination
        TagIn         <= "01010";        --Tag
        PCIn          <= std_logic_vector(to_unsigned(8,32));
        WrEn          <= '1';

        wait for  1*TbPeriod ;

        InstrTypeIn   <= "01";           --Instruction Type
        DestinationIn <= "00011";        --Destination
        TagIn         <= "01001";        --Tag
        PCIn          <= std_logic_vector(to_unsigned(12,32));
        WrEn          <= '1';
        
        wait for  1*TbPeriod ;

        InstrTypeIn   <= "01";           --Instruction Type
        DestinationIn <= "00100";        --Destination
        TagIn         <= "01001";        --Tag
        PCIn          <= std_logic_vector(to_unsigned(16,32));
        WrEn          <= '1';
        ExceptionIn   <= '1';

        wait for  1*TbPeriod ;

        InstrTypeIn   <= "01";           --Instruction Type
        DestinationIn <= "00101";        --Destination
        TagIn         <= "01001";        --Tag
        PCIn          <= std_logic_vector(to_unsigned(20,32));
        WrEn          <= '1';
        ExceptionIn   <= '0';

        wait for  1*TbPeriod ;
        WrEn          <= '0';
        wait for  3*TbPeriod ;

        CDBQ <= "01001";
        CDBV <= std_logic_vector(to_unsigned(512,32));
        wait for 1*TbPeriod;
        CDBQ <= (others => '0');
        CDBV <= (others => '0');
        wait for 1*TbPeriod;

        CDBQ <= (others => '0');
        CDBV <= (others => '0');

        wait for  3*TbPeriod ;
        CDBQ <= "01011";
        CDBV <= std_logic_vector(to_unsigned(1024,32));
        wait for 1*TbPeriod;
        CDBQ <= (others => '0');
        CDBV <= (others => '0');

        wait for  5*TbPeriod ;
        CDBQ <= "01010";
        CDBV <= std_logic_vector(to_unsigned(2048,32));
        wait for 1*TbPeriod;
        CDBQ <= (others => '0');
        CDBV <= (others => '0');

        -- EDIT Add stimuli here
        wait for 100 * TbPeriod;
    end if;
    TbSimEnded <= '1';

    end process;

end tb;