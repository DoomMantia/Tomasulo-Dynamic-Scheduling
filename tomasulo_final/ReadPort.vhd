library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.Bus32pkg.ALL;
entity ReadPort is
	Port ( ReadAddr : in STD_LOGIC_VECTOR (4 downto 0);
		DestinationsIn: in Bus16x5;
		ValuesIn: in Bus16;
		TagsIn: in Bus16x5;
		Newest: in STD_LOGIC_VECTOR(15 downto 0);
		Available : out STD_LOGIC;
		Value: out STD_LOGIC_VECTOR (31 downto 0);
		Tag: out STD_LOGIC_VECTOR(4 downto 0));
end ReadPort;
architecture Behavioural of ReadPort is
begin
	process(ReadAddr, DestinationsIn, ValuesIn, TagsIn)
	begin
		if ReadAddr=DestinationsIn(0) and Newest(0) ='1' then
			Value<=ValuesIn(0);
			Tag<=TAgsIn(0);
			Available <= '1';
		elsif ReadAddr=DestinationsIn(1) and Newest(1) ='1' then
			Value<=ValuesIn(1);
			Tag<=TAgsIn(1);
			Available <= '1';
		elsif ReadAddr=DestinationsIn(2) and Newest(2) ='1' then
			Value<=ValuesIn(2);
			Tag<=TAgsIn(2);
			Available <= '1';
		elsif ReadAddr=DestinationsIn(3) and Newest(3) ='1' then
			Value<=ValuesIn(3);
			Tag<=TAgsIn(3);
			Available <= '1';
		elsif ReadAddr=DestinationsIn(4) and Newest(4) ='1' then
			Value<=ValuesIn(4);
			Tag<=TAgsIn(4);
			Available <= '1';
		elsif ReadAddr=DestinationsIn(5) and Newest(5) ='1' then
			Value<=ValuesIn(5);
			Tag<=TAgsIn(5);
			Available <= '1';
		elsif ReadAddr=DestinationsIn(6) and Newest(6) ='1' then
			Value<=ValuesIn(6);
			Tag<=TAgsIn(6);
			Available <= '1';
		elsif ReadAddr=DestinationsIn(7) and Newest(7) ='1' then
			Value<=ValuesIn(7);
			Tag<=TAgsIn(7);
			Available <= '1';
		elsif ReadAddr=DestinationsIn(8) and Newest(8) ='1' then
			Value<=ValuesIn(8);
			Tag<=TAgsIn(8);
			Available <= '1';
		elsif ReadAddr=DestinationsIn(9) and Newest(9) ='1' then
			Value<=ValuesIn(9);
			Tag<=TAgsIn(9);
			Available <= '1';
		elsif ReadAddr=DestinationsIn(10) and Newest(10)='1'  then
			Value<=ValuesIn(10);
			Tag<=TAgsIn(10);
			Available <= '1';
		elsif ReadAddr=DestinationsIn(11) and Newest(11)='1'  then
			Value<=ValuesIn(11);
			Tag<=TAgsIn(11);
			Available <= '1';
		elsif ReadAddr=DestinationsIn(12) and Newest(12)='1'  then
			Value<=ValuesIn(12);
			Tag<=TAgsIn(12);
			Available <= '1';
		elsif ReadAddr=DestinationsIn(13) and Newest(13)='1'  then
			Value<=ValuesIn(13);
			Tag<=TAgsIn(13);
			Available <= '1';
		elsif ReadAddr=DestinationsIn(14) and Newest(14)='1'  then
			Value<=ValuesIn(14);
			Tag<=TAgsIn(14);
			Available <= '1';
		elsif ReadAddr=DestinationsIn(15) and Newest(15)='1'  then
			Value<=ValuesIn(15);
			Tag<=TAgsIn(15);
			Available <= '1';
		else
			Available <= '0';
			Tag <= "00000";
			Value <= "00000000000000000000000000000000";
		end if;
	end process;
end Behavioural;