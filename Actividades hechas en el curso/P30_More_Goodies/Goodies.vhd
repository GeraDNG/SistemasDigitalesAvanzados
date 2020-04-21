----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:21:49 11/25/2015 
-- Design Name: 
-- Module Name:    Goodies - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity Goodies is
    Port ( A 	: in  	STD_LOGIC;
           B 	: in  	STD_LOGIC;
			  Sel : in 		STD_LOGIC;
           Y 	: out  	STD_LOGIC);
end Goodies;

architecture Behavioral of Goodies is

begin

	BUFGMUX_1_inst : BUFGMUX_1
	port map (
		O 	=> Y, 	-- Clock MUX output
		I0	=> A, 	-- Clock0 input
		I1	=> B, 	-- Clock1 input
		S 	=> Sel 		-- Clock select input
	);

end Behavioral;

