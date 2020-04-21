library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity RWM is
    Port ( Addr 	: in  	STD_LOGIC_VECTOR (3 downto 0);
           WClk 	: in  	STD_LOGIC;
           WE 		: in  	STD_LOGIC;
           Data 	: inout  STD_LOGIC_VECTOR (7 downto 0));
end RWM;

architecture Behavioral of RWM is
	-- Memory Structure:
 	-- Declare a Memory structure used by the ROM
	-- Specify the number of location first, followed by the size of each locations.

	type RWM_type is array (0 to 15) of STD_LOGIC_VECTOR (7 downto 0);
	signal RWM : RWM_type;

begin

	-- WRITTE MEMORY
	-- Data is written into memory in a synchronous way:
	write_RWM: process (WClk, WE)
	begin
		if (rising_edge(WClk)) then
			if (WE = '1') then
				RWM(CONV_INTEGER (Addr)) <= Data;
			end if;
		end if;
	end process write_RWM;
	
	-- READ MEMORY
	-- Data is read into memory in an asynchronous way:
	Data <= RWM(CONV_INTEGER (Addr));

end Behavioral;

