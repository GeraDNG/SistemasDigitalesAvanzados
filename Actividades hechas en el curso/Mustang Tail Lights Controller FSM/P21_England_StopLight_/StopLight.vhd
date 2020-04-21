library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity StopLight is
    Port ( 
           Clk       	: in    STD_LOGIC;
			  Rst       	: in    STD_LOGIC;
--			  GreenLight	: out	  STD_LOGIC;
--			  AmberLight	: out	  STD_LOGIC;
--			  RedLight		: out	  STD_LOGIC;
			  AUX 		 	: out STD_LOGIC_VECTOR (2 downto 0));
end StopLight;

architecture Behavioral of StopLight is

  --Codificar estados en combinaciones binarias 
  type state_values is (RED, REDAMBER, GREEN, AMBER);
  signal pres_state, next_state: state_values;

  --Declaraciones de constantes
  constant Fosc    		 : integer := 100000000;    	--Frecuencia del oscilador de tabletas NEXYS 3
  constant Fdiv    		 : integer := 1;           	--Frecuencia deseada del divisor
  constant CtaMax  		 : integer := Fosc / Fdiv; 	--Cuenta maxima a la que hay que llegar
  constant tRed	 		 : integer := 20;
  constant tRedAmber	 	 : integer := 5;
  constant tGreen	 		 : integer := 30;
  constant tAmber	 		 : integer := 5;
  
  --Declaracion de signals
  signal Cont      : integer range 0 to CtaMax;
  signal TimeBase	 : STD_LOGIC;
  --Declaracion de signals para determinar el tiempo de cada estado
  signal SecondCount : integer range 0 to tGreen;
  signal SecondState : integer range 0 to tGreen;

begin

  --Proceso que Divide la Frecuencia de entrada para obtener una Frecuencia de 1 Hz (1 segundo)
  process (Rst, Clk)
  begin
    if Rst = '1' then
	   Cont <= 0;
	 elsif (rising_edge(Clk)) then
	   if Cont = CtaMax then
        Cont <= 0;
        TimeBase <= '1';
      else		  
	     Cont <= Cont + 1;
		  TimeBase<= '0';
		end if;
	end if;
  end process;
-----------------------------------------------------------------------------------------------

	statereg: process (Clk, TimeBase, Rst)
	begin
		if (Rst='1') then 
			pres_state <= RED;
			SecondCount <= 0;
		elsif (rising_edge(Clk) and TimeBase = '1') then
			if (SecondCount = SecondState-1) then
				pres_state <= next_state;
				SecondCount <= 0;
			else
				SecondCount <= SecondCount + 1;
			end if;
		end if;
	end process statereg;

-----------------------------------------------------------------------------------------------

	fsm: process (pres_state)
	begin
		case (pres_state) is 
			when RED =>
				next_state <= REDAMBER;
				SecondState <= tRed;
			when REDAMBER =>
				next_state <= GREEN;
				SecondState <= tRedAmber;
			when GREEN =>
				next_state <= AMBER;
				SecondState <= tGreen;
			when AMBER =>
				next_state <= RED;
				SecondState <= tAmber;
			when others =>
				next_state <= RED;
				SecondState <= tRed;
		end case;
	end process fsm;

-----------------------------------------------------------------------------------------------

--	AUX <= (RedLight & AmberLight & GreenLight);
	output: process (pres_state)
	begin
		case (pres_state) is
			when RED 		=> AUX <= "100";  	
			when REDAMBER 	=> AUX <= "110";
			when GREEN 		=> AUX <= "001";
			when AMBER 		=> AUX <= "010";
			when others 	=> AUX <= "100";
		end case;
	end process output;

-----------------------------------------------------------------------------------------------

end Behavioral;

