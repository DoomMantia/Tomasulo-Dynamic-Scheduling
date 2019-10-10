library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;
entity RSSelectArithmetic is
    Port ( Executable : in STD_LOGIC_VECTOR (2 downto 0);
           Clk : in STD_LOGIC;
           Rst : in STD_LOGIC;
           Tag : out STD_LOGIC_VECTOR (2 downto 0));
end RSSelectArithmetic;
architecture Behavioral of RSSelectArithmetic is
signal priority: std_logic_vector(1 downto 0);
begin
	process(Executable, Clk, Rst)
	begin
		if Rst='1' then
			priority<="00";
			Tag<="000";
		else
			if priority="00" then
				if Executable(0)='1' then
					Tag<="001";
					priority<="01";
				elsif Executable(1)='1' then
					Tag<="010";
					priority<="01";
				elsif Executable(2)='1' then
					Tag<="011";
					priority<="01";
				else
					Tag<="000";
				end if;
			elsif priority="01" then
				if Executable(1)='1' then
					Tag<="010";
					priority<="10";
				elsif Executable(2)='1' then
					Tag<="011";
					priority<="10";
				elsif Executable(0)='1' then
					Tag<="001";
					priority<="10";
				else
					Tag<="000";
				end if;
			else
				if Executable(2)='1' then
					Tag<="011";
					priority<="00";
				elsif Executable(0)='1' then
					Tag<="001";
					priority<="00";
				elsif Executable(1)='1' then
					Tag<="010";
					priority<="00";
				else
					Tag<="000";
				end if;
			end if;
		end if;
	end process;
end Behavioral;