----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:38:58 12/04/2018 
-- Design Name: 
-- Module Name:    controller - Behavioral 
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
-- use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity controller is
    Port ( p1, p0 : in  STD_LOGIC;
			  f : in STD_LOGIC;
           clk, rst : in  STD_LOGIC;
           continue : in  STD_LOGIC;
           B1, B2 : out  STD_LOGIC;
           sirena : out  STD_LOGIC);
end controller;

architecture Behavioral of controller is
type state is (start, waiting, loading, full_box, full_pallet);
signal cstate, nstate : state;
signal weight, nweight : integer range 0 to 4;
signal box, nbox : integer range 0 to 9;
signal count, ncount : integer range 0 to 9;
signal timeover : std_logic :='0';
signal timer : std_logic :='0';

begin

-- Salvo lo stato corrente e i valori dei contatori.
up_state: process(clk)
begin
	if rising_edge(clk) then
		if (rst='1') then 
			cstate <= start;
			weight <= 0;
			box <= 0;
			count <= 0;
		else
			cstate <= nstate;
			weight <= nweight;
			box <= nbox;
			count <= ncount;
		end if;
	end if;
end process;

-- Aggiorno lo stato prossimo e le uscite.
Finite_State_Machine: process(cstate, p1, p0, f, continue, timeover, weight, box)
-- tmp_out = sirena & timer & B2 & B1
variable tmp_out : std_logic_vector(3 downto 0);
begin
case (cstate) is
	-- Aspetto che una scatola venga messa in posizione 
	when start => 
					tmp_out := "0000";
					nweight <= weight;
					nbox <= box;
					if f = '1' then
						nstate <= waiting;
					else
						nstate <= start;
					end if;
					
	-- Aspetto che arrivi un oggetto sul nastro e scelgo se metterlo nella scatola o meno			
	when waiting => 
					tmp_out := "0000";
					nbox <= box;
					-- Arriva un oggetto di 1kg
					if (p1 = '0' and p0 = '1') then
						nstate <= loading;
						nweight <= weight + 1;
					-- Arriva un oggetto di 2kg
					elsif (p1 = '1' and p0 = '0' and weight < 3) then
						nstate <= loading;
						nweight <= weight + 2;
					-- Non arriva nessun oggetto
					else
						nstate <= waiting;
						nweight <= weight;
					end if;
					
	-- Aspetto che la macchina finisca di caricare l'oggetto nella scatola
	when loading => 
					tmp_out := "0101";
					nbox <= box;
					if timeover = '1' then
						if weight = 4 then
							nstate <= full_box;
							nweight <= 0;
						else
							nstate <= waiting;
							nweight <= weight;
						end if;
					else
						nstate <= loading;
						nweight <= weight;
					end if;
			
	-- Sposto la scatola sul pallet
	when full_box =>
					tmp_out := "0010";
					nweight <= weight;
					-- La prossima scatola riempira' il pallet
					if box = 9 then
						nstate <= full_pallet;
						nbox <= 0;
					else
						nstate <= start;
						nbox <= box + 1;
					end if;
					
	-- Attivo la sirena ed aspetto il segnale da parte dell'operatore
	when full_pallet =>
					tmp_out := "1000";
					nweight <= weight;
					nbox <= box;
					if continue = '1' then
						nstate <= start;
					else 
						nstate <= full_pallet;
					end if;
end case;
sirena <= tmp_out(3);
timer <= tmp_out(2);
B2 <= tmp_out(1);
B1 <= tmp_out(0);
end process;

-- Contatore per il caricamento di un oggetto nella scatola
counter_timer: process(timer, count)
begin
	if timer = '1' then
		if count = 9 then
			ncount <= 0;
			timeover <= '1';
		else
			ncount <= count + 1;
			timeover <= '0';
		end if;
	else
		ncount <= count;
		timeover <= '0';
	end if;
end process;	
end Behavioral;

