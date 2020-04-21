----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:31:38 12/04/2015 
-- Design Name: 
-- Module Name:    aspira - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity aspira is
 Port (
	Switch   		: in  STD_LOGIC;
	motor_aspira   : out  STD_LOGIC);
end aspira;

architecture Behavioral of aspira is

begin
	aspira: process (switch)
	begin
	if (switch ='1') then
		motor_aspira<='1';
	else
	   motor_aspira<='0';
	end if;
	end process aspira;

end Behavioral;

