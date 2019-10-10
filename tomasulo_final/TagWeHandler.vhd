library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
entity TagWrEnHandler is
    Port ( AddrW : in STD_LOGIC_VECTOR (4 downto 0);
           WrEn : in STD_LOGIC;
           Output : out STD_LOGIC_VECTOR (31 downto 0));
end TagWrEnHandler;
architecture Behavioral of TagWrEnHandler is
component Decoder5to32 is
    Port ( Input : in STD_LOGIC_VECTOR (4 downto 0);
           Output : out STD_LOGIC_VECTOR (31 downto 0));
end component;
signal decoderOut: std_logic_vector(31 downto 0);
begin
	Decoder5to32_0: Decoder5to32 port map(Input=>AddrW, Output=>decoderOut); 

	process(AddrW,WrEn, decoderOut)
	begin
		if WrEn='1' then
			Output<=decoderOut;
		else
			Output<=std_logic_vector(to_unsigned(0,32));
		end if;
	end process;
end Behavioral;
