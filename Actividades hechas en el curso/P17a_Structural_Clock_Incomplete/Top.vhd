----------------------------------------------------------------------------------
-- Company: ITESM
-- Engineer: RickWare
-- 
-- Create Date:    07:22:58 10/06/2010 
-- Design Name:    Reloj Jerarquico
-- Module Name:    Top - Behavioral 
-- Project Name:   Reloj_Jerarquico
-- Target Devices: Nexys 2
-- Tool versions:  ISE 11.4
-- Description:    Reloj que despliega HH:MM:SS
--                 HH y MM seran desplegados en displays de 7 segmentos
--                 SS seran desplegados en los LEDs
-- Dependencies: 
--
-- Revision: v1.0
-- Revision 0.01 - File Created
-- Additional Comments: Ver diagrama anexo (entregado en clase)
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Top is
    Port ( DecEnt    : in   STD_LOGIC_VECTOR (3 downto 0);
           UniEnt    : in   STD_LOGIC_VECTOR (3 downto 0);
           HorEn     : in   STD_LOGIC;
           MinEn     : in   STD_LOGIC;
           Rst       : in   STD_LOGIC;
           Clk100MHz : in   STD_LOGIC;
           Seg       : out  STD_LOGIC_VECTOR (7 downto 0);
           SegOut    : out  STD_LOGIC_VECTOR (7 downto 0);
           Disp      : out  STD_LOGIC_VECTOR (3 downto 0));
end Top;

architecture Behavioral of Top is
  --Declaracion de todos los componentes usados en el dise�o
  
  --Componente U1: Genera una se�al de 1Hz a partir del reloj de entrada de 100MHz
  component Clk1Hz
  port (
    Rst    : in  STD_LOGIC;
    Clk    : in  STD_LOGIC;
	 ClkOut : out STD_LOGIC);
  end component;

  --Componentes U2 y U4: Contadores de 0 a 9 (BCD) usados para las Unidades de Segundo
  --                     y las Unidades de Minuto respectivamente
  component Cont0a9
  port (
    Load   : in  STD_LOGIC;
    Enable : in  STD_LOGIC;
	 Rst    : in  STD_LOGIC;
	 Clk    : in  STD_LOGIC;
	 Valor  : in  STD_LOGIC_VECTOR (3 downto 0);
	 TCO    : out STD_LOGIC;
	 Cuenta : out STD_LOGIC_VECTOR (3 downto 0));
  end component;

  --Componentes U3 y U5: Contadores de 0 a 5 (BCD) usados para las Decenas de Segundo
  --                     y las Decenas de Minuto respectivamente
  component Cont0a5
  port (
    Load   : in  STD_LOGIC;
    Enable : in  STD_LOGIC;
	 Rst    : in  STD_LOGIC;
	 Clk    : in  STD_LOGIC;
	 Valor  : in  STD_LOGIC_VECTOR (3 downto 0);
	 TCO    : out STD_LOGIC;
	 Cuenta : out STD_LOGIC_VECTOR (3 downto 0));
  end component;  
  
  --Componentes U6: Contadores de 0 a 23 (BCD) usado para las Horas en formado militar (23 horas)
  component Cont0a23
  port (
    Load      : in  STD_LOGIC;
    Enable    : in  STD_LOGIC;
	 Rst       : in  STD_LOGIC;
	 Clk       : in  STD_LOGIC;
	 ValorDec  : in  STD_LOGIC_VECTOR (3 downto 0);
	 ValorUni  : in  STD_LOGIC_VECTOR (3 downto 0);
	 Cuenta    : out STD_LOGIC_VECTOR (7 downto 0));
  end component; 

  --Componente U7: Genera una se�al de Refresh para los displays de 7 segmentos multiplexados
  --               a partir del reloj de entrada de 100MHz

  
  --Componente U8: Contador de 0 a 3 (binario) cuya cuenta determina que valor del tiempo
  --               se va a desplegar. Tambien selecciona en que display sera desplegado.

  
  --Componente U9: Multiplexor de buses de 4-bits de 4 a 1. Su funcion es seleccionar entre
  --               uno de los digitos que forman la hora HH:MM y mandarlo al decodificador
  --               de BCD a 7 Segmentos

  
  --Componente U10: Selecciona el Display a encender, mandando un 0 logico a su Anodo

  
  --Componente U11: Decodificador de BCD a 7 Segmentos

  
  --Declaracion de todas las se�ales embebidas (verde y azul en su esquematico), sufijo "_int"
  --Se�ales embebidas de 1-bit
  signal EnHoras_int    : STD_LOGIC;
  signal EnDecMin_int   : STD_LOGIC;
  signal EnUniMin_int   : STD_LOGIC;
  signal EnSeg_int      : STD_LOGIC;
  signal EnDecSeg_int   : STD_LOGIC;
  signal Clk1Hz_int     : STD_LOGIC;
  signal TCODecMin_int  : STD_LOGIC;
  signal TCOUniMin_int  : STD_LOGIC;

  
  --Se�ales embebidas de mas de 1-bit
  signal Hor_int        : STD_LOGIC_VECTOR (7 downto 0);  
  signal DecMin_int     : STD_LOGIC_VECTOR (3 downto 0);

  
begin
  --Instanciar los componentes (alambrar los componentes)
  --Se usara el metodo corto in Instantiation
  
  U1 : Clk1Hz
    port map (
	   Rst,
		Clk100MHz,
		Clk1HZ_int);

  U2 : Cont0a9
    port map (
	   EnSeg_int,
		Clk1Hz_int,
		Rst,
		Clk100MHz,
		"0000",
		TCOUniSeg_int,
		SegOut(3 downto 0));
	 
  U3 : Cont0a5
    port map (
	   EnSeg_int,
		EnDecSeg_int,
		Rst,
		Clk100MHz,
		"0000",
		TCODecSeg_int,
		SegOut(7 downto 4));
		
  U4 : Cont0a9
    port map (
	   MinEn,
		EnUniMin_int,
		Rst,
		Clk100MHz,
		UniEnt,
		TCOUniMin_int,
		UniMin_int);
		
  U5 : Cont0a5
    port map (
	   MinEn,
		EnDecMin_int,
		Rst,
		Clk100MHz,
		DecEnt,
		TCODecMin_int,
		DecMin_int);
		
  U6 : Cont0a23
    port map (
	   HorEn,
		EnHoras_int,
		Rst,
		Clk100MHz,
		DecEnt,
		UniEnt,
		Hor_int);
		

		
  --Instanciar las compuertas
  EnHoras_int  <= EnDecMin_int  and TCODecMin_int and Clk1Hz_int;
  EnDecMin_int <= EnUniMin_int  and TCOUniMin_int and Clk1Hz_int;

		
end Behavioral;

