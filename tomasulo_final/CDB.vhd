library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
entity CDB is
    Port ( QArithmetic : in STD_LOGIC_VECTOR (4 downto 0);
           VArithmetic : in STD_LOGIC_VECTOR (31 downto 0);
           QLogical : in STD_LOGIC_VECTOR (4 downto 0);
           VLogical : in STD_LOGIC_VECTOR (31 downto 0);
           QBuffer : in STD_LOGIC_VECTOR (4 downto 0);
           VBuffer : in STD_LOGIC_VECTOR (31 downto 0);
           ArithmeticRequest : in STD_LOGIC;
           LogicalRequest : in STD_LOGIC;
           BufferRequest : in STD_LOGIC;
           Clk : in STD_LOGIC;
           Rst : in STD_LOGIC;
           Qout : out STD_LOGIC_VECTOR (4 downto 0);
           Vout : out STD_LOGIC_VECTOR (31 downto 0);
           GrantArithmetic: out STD_LOGIC;
           GrantLogical: out STD_LOGIC;
           GrantBuffer: out STD_LOGIC);
end CDB;
architecture Behavioral of CDB is
	Signal priority, currentSelected, nextSelected: std_logic_vector(1 downto 0);
begin
	process(Clk, Rst)
	begin
		if Rst='1' then
			priority<="00";
			GrantArithmetic<='0';
			GrantLogical<='0';
   			GrantBuffer<='0';
   			nextSelected<="00";
		elsif rising_edge(clk) then
			if priority="00" then
				if ArithmeticRequest='1' then
					nextSelected<="01";
					GrantArithmetic<='1';
					GrantLogical<='0';
					GrantBuffer<='0';
					priority<="01";
				elsif LogicalRequest='1' then
					nextSelected<="10";
					GrantArithmetic<='0';
					GrantLogical<='1';
					GrantBuffer<='0';
					priority<="01";
				elsif BufferRequest='1' then
					nextSelected<="11";
					GrantArithmetic<='0';
					GrantLogical<='0';
					GrantBuffer<='1';
					priority<="01";
				else
					nextSelected<="00";
					GrantArithmetic<='0';
					GrantLogical<='0';
					GrantBuffer<='0';
				end if;
			elsif priority="01" then
				if LogicalRequest='1' then
					nextSelected<="10";
					GrantArithmetic<='0';
					GrantLogical<='1';
					GrantBuffer<='0';
					priority<="10";
				elsif BufferRequest='1' then
					nextSelected<="11";
					GrantArithmetic<='0';
					GrantLogical<='0';
					GrantBuffer<='1';
					priority<="10";
				elsif ArithmeticRequest='1' then
					nextSelected<="01";
					GrantArithmetic<='1';
					GrantLogical<='0';
					GrantBuffer<='0';
					priority<="10";
				else
					nextSelected<="00";
					GrantArithmetic<='0';
					GrantLogical<='0';
					GrantBuffer<='0';
				end if;
			else
				if BufferRequest='1' then
					nextSelected<="11";
					GrantArithmetic<='0';
					GrantLogical<='0';
					GrantBuffer<='1';
					priority<="00";
				elsif ArithmeticRequest='1' then
					nextSelected<="01";
					GrantArithmetic<='1';
					GrantLogical<='0';
					GrantBuffer<='0';
					priority<="00";
				elsif LogicalRequest='1' then
					nextSelected<="10";
					GrantArithmetic<='0';
					GrantLogical<='1';
					GrantBuffer<='0';
					priority<="00";
				else
					nextSelected<="00";
					GrantArithmetic<='0';
					GrantLogical<='0';
					GrantBuffer<='0';
				end if;
			end if;
		end if;
	end process;

	process(Clk, Rst,currentSelected,nextSelected)
	begin
		if Rst='1' then
			currentSelected<="00";
		elsif rising_edge(Clk) then
			currentSelected<=nextSelected;
		end if;
	end process;

	with currentSelected select
		Qout <= QArithmetic 						when "01",
				QLogical 							when "10",
				QBuffer 							when "11",
				std_logic_vector(to_unsigned(0,5)) 	when others;
	
	with currentSelected select
		Vout <= VArithmetic 						when "01",
				VLogical 							when "10",
				VBuffer 							when "11",
				std_logic_vector(to_unsigned(0,32))	when others;
end Behavioral;