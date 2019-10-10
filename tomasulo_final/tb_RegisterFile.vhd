library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity tb_RegisterFile is
end tb_RegisterFile;

architecture tb of tb_RegisterFile is
    component RegisterFile
        Port ( ReadAddr1 : in STD_LOGIC_VECTOR (4 downto 0);
               ReadAddr2 : in STD_LOGIC_VECTOR (4 downto 0);
               CDBQ : in STD_LOGIC_VECTOR (4 downto 0);
               CDBV : in STD_LOGIC_VECTOR (31 downto 0);
               Tag : in STD_LOGIC_VECTOR (4 downto 0);
               WrEn : in STD_LOGIC;
               AddrW : in STD_LOGIC_VECTOR (4 downto 0);
               Clk : in STD_LOGIC;
               Rst : in STD_LOGIC;
               DataOut1 : out STD_LOGIC_VECTOR (31 downto 0);
               TagOut1: out STD_LOGIC_VECTOR (4 downto 0);
               DataOut2 : out STD_LOGIC_VECTOR (31 downto 0);
               TagOut2: out STD_LOGIC_VECTOR (4 downto 0));
    end component;

    signal ReadAddr1 : std_logic_vector (4 downto 0);
    signal ReadAddr2 : std_logic_vector (4 downto 0);
    signal CDBQ      : std_logic_vector (4 downto 0);
    signal CDBV      : std_logic_vector (31 downto 0);
    signal Tag       : std_logic_vector (4 downto 0);
    signal WrEn      : std_logic;
    signal AddrW     : std_logic_vector (4 downto 0);
    signal Clk       : std_logic;
    signal Rst       : std_logic;
    signal DataOut1  : std_logic_vector (31 downto 0);
    signal TagOut1   : std_logic_vector (4 downto 0);
    signal DataOut2  : std_logic_vector (31 downto 0);
    signal TagOut2   : std_logic_vector (4 downto 0);

    constant TbPeriod : time := 10 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : RegisterFile
    port map (ReadAddr1 => ReadAddr1,
              ReadAddr2 => ReadAddr2,
              CDBQ      => CDBQ,
              CDBV      => CDBV,
              Tag       => Tag,
              WrEn      => WrEn,
              AddrW     => AddrW,
              Clk       => Clk,
              Rst       => Rst,
              DataOut1  => DataOut1,
              TagOut1   => TagOut1,
              DataOut2  => DataOut2,
              TagOut2   => TagOut2);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that Clk is really your main clock signal
    Clk <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        ReadAddr1 <= (others => '0');
        ReadAddr2 <= (others => '0');
        CDBQ <= (others => '0');
        CDBV <= (others => '0');
        Tag <= (others => '0');
        WrEn <= '0';
        AddrW <= (others => '0');

        -- Reset generation
        -- EDIT: Check that Rst is really your reset signal
        Rst <= '1';
        wait for 100 ns;
        Rst <= '0';
        wait for 100 ns;

        -- EDIT Add stimuli here
        WrEn<='1';
        for i in 0 to 4 loop
       		AddrW<=std_logic_vector(to_unsigned(i,5));
       		Tag<=std_logic_vector(to_unsigned(i,5));
        	wait for 10 * TbPeriod;
		end loop;
		for i in 0 to 4 loop
			CDBQ<=std_logic_vector(to_unsigned(i,5));
			CDBV<=std_logic_vector(to_unsigned(i,32));
			wait for 10 * TbPeriod;
		end loop;
		for i in 0 to 4 loop
			ReadAddr1<=std_logic_vector(to_unsigned(i,5));
			ReadAddr2<=std_logic_vector(to_unsigned(i,5));
			wait for 10 * TbPeriod;
		end loop;
        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;
end tb;