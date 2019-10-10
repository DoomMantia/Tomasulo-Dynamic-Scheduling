library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity Counter4 is
	port( Enable: in std_logic;
		DataIn: in std_logic_vector(3 downto 0);
		Load: in std_logic;
		Clk: in std_logic;
		Rst: in std_logic;
		Output: out std_logic_vector(0 to 3));
end Counter4;
architecture Behavioral of Counter4 is
	signal temp: std_logic_vector(0 to 3);
begin   
	process(Clk,Rst)
	begin
		if Rst='1' then
			temp <= "0000";
		elsif(rising_edge(Clk)) then
			if Load='1' then
				temp<=DataIn;
			else 
				if Enable='1' then
					temp <= temp + 1;
				end if;
			end if;
		end if;
	end process;
	Output <= temp;
end Behavioral;