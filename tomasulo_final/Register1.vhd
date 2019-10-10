library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity Register1 is
  Port ( DataIn : in STD_LOGIC;
         WrEn : in STD_LOGIC;
         Rst : in STD_LOGIC;
         Clk : in STD_LOGIC;
         DataOut : out STD_LOGIC);
end Register1;
architecture Structural of Register1 is
	component Mux2
		Port (	input 	: in  	STD_LOGIC_VECTOR (1 downto 0);
			output 	: out  	STD_LOGIC;
			control	: in  	STD_LOGIC);
	end component;
	component DFlipFlop
	    Port (	D 	: in  	STD_LOGIC;
			reset	: in  	STD_LOGIC;
			clk 	: in  	STD_LOGIC;
			Q 	: out  STD_LOGIC);
	end component;
	signal mux2out, DFlipFlopOut : STD_LOGIC;
begin
	mux2_0: Mux2 port map(input(0)=>DFlipFlopOut, input(1)=>DataIn, output=>mux2out, control=>WrEn);
	DFlipFlop0: DFlipFlop port map(D=>mux2out, reset=>Rst, clk=>Clk, Q=>DFlipFlopOut);
	DataOut<=DFlipFlopOut;
end Structural;
