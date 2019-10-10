--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   14:24:46 10/29/2018
-- Design Name:   
-- Module Name:   /home/amanesis/Desktop/HRY415-v2/testbench_logicalunit1.vhd
-- Project Name:  HRY415-v2
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: LogicalUnit1
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY testbench_logicalunit1 IS
END testbench_logicalunit1;
 
ARCHITECTURE behavior OF testbench_logicalunit1 IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT LogicalUnit1
    PORT(
         Vj : IN  std_logic_vector(31 downto 0);
         Vk : IN  std_logic_vector(31 downto 0);
         Op : IN  std_logic_vector(1 downto 0);
         DataOut : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal Vj : std_logic_vector(31 downto 0) := (others => '0');
   signal Vk : std_logic_vector(31 downto 0) := (others => '0');
   signal Op : std_logic_vector(1 downto 0) := (others => '0');

 	--Outputs
   signal DataOut : std_logic_vector(31 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 

 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: LogicalUnit1 PORT MAP (
          Vj => Vj,
          Vk => Vk,
          Op => Op,
          DataOut => DataOut
        );


        Vj <= "00000000000000000000000000000001" ;
        Vk <= "00000000000000000000000000000010" ;
        Op <= "00";



END;
