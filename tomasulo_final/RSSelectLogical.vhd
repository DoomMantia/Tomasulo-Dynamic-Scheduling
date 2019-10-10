library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;
entity RSSelectLogical is
    Port ( Executable : in STD_LOGIC_VECTOR (1 downto 0);
    	   Clk : in STD_LOGIC;
           Rst : in STD_LOGIC;
           Tag : out STD_LOGIC_VECTOR (2 downto 0));
end RSSelectLogical;
architecture Behavioral of RSSelectLogical is
signal priority: std_logic;
begin

	process(Executable,clk,rst)
	begin
		if Rst='1' then
			priority<='0';
			Tag<="000";
		else 
			if priority='1' then
				if Executable(0)='1' then
					priority<='1';
					Tag<="001";
				elsif Executable(1)='1' then
					priority<='1';
					Tag<="010";
				else
					Tag<="000";
				end if;
			else
				if Executable(1)='1' then
					priority<='0';
					Tag<="010";
				elsif Executable(0)='1' then
					priority<='0';
					Tag<="001";
				else
					Tag<="000";
				end if;
			end if;
		end if;
	end process;
end Behavioral;