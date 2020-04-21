LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY RWM_tb IS
END RWM_tb;
 
ARCHITECTURE behavior OF RWM_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT RWM
    PORT(
         Addr 	: IN  	std_logic_vector(3 downto 0);
         WClk 	: IN  	std_logic;
         WE 	: IN  	std_logic;
         Data 	: INOUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal Addr : std_logic_vector(3 downto 0) := (others => '0');
   signal WClk : std_logic := '0';
   signal WE 	: std_logic := '0';

	--BiDirs
   signal Data : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant WClk_period : time := 100 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: RWM PORT MAP (
          Addr => Addr,
          WClk => WClk,
          WE => WE,
          Data => Data
        );

   -- Clock process definitions
   WClk_process :process
   begin
		WClk <= '0';
		wait for WClk_period/2;
		WClk <= '1';
		wait for WClk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for WClk_period*1;

      -- insert stimulus here
			-- Write number to the RWM:
			WE <= '1';
			Addr <= x"3";	Data <= x"35";	wait for WClk_period*1;
			Addr <= x"A";	Data <= x"BC";	wait for WClk_period*1;
			Addr <= x"F";	Data <= x"96";	wait for WClk_period*1;
			--Read numebers from RWM:
			WE <= '0';
			Addr <= x"F";	wait for WClk_period*1;
			Addr <= x"A";	wait for WClk_period*1;
			Addr <= x"3";	wait for WClk_period*1;

      wait;
   end process;

END;
