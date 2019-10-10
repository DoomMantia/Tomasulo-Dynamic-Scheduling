library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity Register48 is
    Port ( DataIn : in STD_LOGIC_VECTOR(47 downto 0);
           WrEn : in STD_LOGIC;
           Rst : in STD_LOGIC;
           Clk : in STD_LOGIC;
           DataOut : out STD_LOGIC_VECTOR(47 downto 0));
end Register48;
architecture Structural of Register48 is
	component Register1 is
	    Port ( DataIn : in STD_LOGIC;
		   WrEn : in STD_LOGIC;
		   Rst : in STD_LOGIC;
		   Clk : in STD_LOGIC;
		   DataOut : out STD_LOGIC);
	end component;
begin
	register1Generator:
	for i in 0 to 47 generate
		register1_i: Register1 port map(DataIn=>DataIn(i), WrEn=>WrEn, Rst=>Rst, Clk=>Clk, DataOut=>DataOut(i));
	end generate;
end Structural;