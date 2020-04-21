----------------------------------------------------------------------------------
-- Company:        ITESM
-- Engineer:       RickWare 
-- 
-- Create Date:    11:42:22 11/04/2015 
-- Design Name: 
-- Module Name:    Ultrasonic - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies:   Parallax Ultrasonic Sensor controller
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity Ultrasonic is
    Port ( Clk        : in  	STD_LOGIC;
           Rst        : in  	STD_LOGIC;
			  Rx			 : in 	STD_LOGIC;
           Tx         : out  	STD_LOGIC;
           LEDs       : out  	STD_LOGIC_VECTOR(7 downto 0));
end Ultrasonic;

architecture Behavioral of Ultrasonic is
  -- State definition
  type state_values is (StartPulse,WaitForResponse,UltrasonicResponse,WaitForNewStart);
  signal pres_state, next_state : state_values;
  -- Define the State duration times for the variable time duration FSM
  -- All times are expressed in micro-seconds
  constant tStartPulse      : integer := 5;
  constant tWaitForNewStart : integer := 1_000_000;
  -- Define signals used by frequency divider
  constant Fosc     : integer := 100_000_000; --Frecuencia del oscilador de Nexys3 
  constant Fdiv     : integer :=   1_000_000; --Frecuencia deseada del divisor
  constant CtaMax   : integer := Fosc / Fdiv; --Cuenta maxima a la que hay que llegar
  signal   Cont     : integer range 0 to CtaMax;
  signal   TimeBase : STD_LOGIC;
  -- Define a second counter, used to determine how  much
  -- time has been spent in a State
  signal   SecondCount   : integer range 0 to tWaitForNewStart;
  -- Define a signal that gives the amount of time
  -- to be spent in a State
  signal   StateDuration : integer range 0 to tWaitForNewStart;
  -- Signals used to obtain the duration response of the UltraSonicSensor and convert to distance:
  signal Measurement : integer range 0 to 20_000;
  signal tIN			: integer range 0 to 20_000;
    
begin
  -- Generate a TimeBase of one microsecond
  freqdiv: process (Rst, Clk)
  begin
    if Rst = '1' then
	   Cont <= 0;
	 elsif (rising_edge(Clk)) then
	   if Cont = CtaMax then
        Cont     <= 0;
        TimeBase <= '1';
      else		  
	     Cont     <= Cont + 1;
		  TimeBase <= '0';
		end if;
	end if;
  end process freqdiv;  

  statereg : process(Clk,TimeBase,Rst)
  begin
    if Rst = '1' then
	   pres_state  <= StartPulse;
		SecondCount <= 0;
	 elsif (rising_edge(Clk) and TimeBase = '1') then
	   if SecondCount = StateDuration-1 then
	     pres_state  <= next_state;
		  SecondCount <= 0;
		else
		  SecondCount <= SecondCount + 1;
		end if;
	 end if;
  end process statereg;
  
  fsm : process (pres_state, Rx)
  begin
    case (pres_state) is
      -- ST0	 
      when StartPulse =>
         next_state    	<= WaitForResponse;
			StateDuration 	<= tStartPulse;
      -- ST1			
      when WaitForResponse =>
			if (Rx = '1') then
				next_state  <= UltraSonicResponse;
			else
				next_state  <= WaitForResponse;
			end if;
			StateDuration 	<= 1;
		-- ST2
      when UltraSonicResponse =>
			if (Rx = '0') then
				next_state  <= WaitForNewStart;
			else
				next_state  <= UltraSonicResponse;
			end if;
			StateDuration 	<= 1;
		-- ST3
      when WaitForNewStart =>
         next_state    	<= StartPulse;
			StateDuration 	<= tWaitForNewStart;
      when others =>
         next_state    	<= WaitForResponse;
			StateDuration 	<= tStartPulse; 
    end case;
  end process fsm;
  
  -- Measurement equation:
  Measurement <= (tIN * 300)/18500;
  -- Process that counts to have Tin:
  tIN_Counter: process (pres_state, tIN, Clk, TimeBase)
  begin
		if (rising_edge(Clk) and TimeBase = '1') then
			if 	(pres_state = WaitForResponse) 	then
				tIN <= 0;
			elsif (pres_state = UltrasonicResponse) then
				tIN <= tIN + 1;
			elsif (pres_state = WaitForNewStart) 	then
				LEDs <= CONV_STD_LOGIC_VECTOR(Measurement, 8);
			end if;
		end if;
  end process tIN_Counter;
  
  output : process (pres_state)
  begin
    case (pres_state) is 
      when StartPulse         => Tx <= '1';
      when WaitForResponse    => Tx <= '0';
      when UltraSonicResponse => Tx <= '0';
      when WaitForNewStart    => Tx <= '0';
      when others             => Tx <= '1';
    end case;
  end process output;
end Behavioral;