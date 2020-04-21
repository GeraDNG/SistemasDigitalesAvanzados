library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Top is
    Port ( Xin : in  STD_LOGIC_VECTOR (15 downto 0);
           Clk : in  STD_LOGIC;
           Xout : out  STD_LOGIC_VECTOR (8 downto 0);
           Rdy : out  STD_LOGIC);
end Top;

architecture Behavioral of Top is
	component Operation
	-- ...

begin

	-- Instantiate:
	port map (
		-- Xout;
		-- Rdy;
	);

end Behavioral;

