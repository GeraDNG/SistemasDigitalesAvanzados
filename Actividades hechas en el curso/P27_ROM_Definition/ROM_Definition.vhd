library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ROM_Definition is
    Port ( Address 		: in  	STD_LOGIC_VECTOR (3 downto 0);
           Data 			: out  	STD_LOGIC_VECTOR (7 downto 0));
end ROM_Definition;

architecture Behavioral of ROM_Definition is

	-- Declare a Memory structure used by the ROM
	-- Specify the number of location first, followed by the size of each locations.
	type 		ROM_type is array (0 to 15) of STD_LOGIC_VECTOR (7 downto 0);
	constant MemROM : ROM_type :=
		(X"00", X"11", X"22", X"33", X"44", X"55", X"66", X"77",
		 X"88", X"99", X"AA", X"BB", X"CC", X"DD", X"EE", X"FF");

begin

	-- Instiatiate as a ROM:
	Data <= MemROM (CONV_INTEGER(Address));

end Behavioral;

