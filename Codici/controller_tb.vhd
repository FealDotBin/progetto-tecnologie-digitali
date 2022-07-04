--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:45:12 12/04/2018
-- Design Name:   
-- Module Name:   /home/ise/Desktop/Xilinx_Projects/Inscatolamento/controller_tb.vhd
-- Project Name:  Inscatolamento
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: controller
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY controller_tb IS
END controller_tb;
 
ARCHITECTURE behavior OF controller_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT controller
    PORT(
         p1 : IN  std_logic;
         p0 : IN  std_logic;
         f : IN  std_logic;
         clk : IN  std_logic;
         rst : IN  std_logic;
         continue : IN  std_logic;
         B1 : OUT  std_logic;
         B2 : OUT  std_logic;
         sirena : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal p1 : std_logic := '0';
   signal p0 : std_logic := '0';
   signal f : std_logic := '0';
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal continue : std_logic := '0';

 	--Outputs
   signal B1 : std_logic;
   signal B2 : std_logic;
   signal sirena : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: controller PORT MAP (
          p1 => p1,
          p0 => p0,
          f => f,
          clk => clk,
          rst => rst,
          continue => continue,
          B1 => B1,
          B2 => B2,
          sirena => sirena
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- Sequenza di reset
		rst <= '1';
      wait for clk_period;
		rst <= '0';
		wait for clk_period;

		-- Carico 10 scatole per verificare che lo stato Full_pallet venga attivato
		for i in 1 to 10 loop
			-- Al prossimo colpo di clock l'automa evolvera' in waiting
			f <= '1';
			wait for clk_period;
			
			-- Carico due oggetti da 2kg per riempire velocemente la scatola
			for j in 1 to 2 loop 
				-- Al prossimo colpo di clock l'automa passera' allo stato di loading
				p1 <= '1';
				p0 <= '0';
				wait for clk_period;
				p1 <= '0';
			
				-- Attendo 10 colpi di clock (tempo impiegato dal braccio per spostare un oggetto)
				wait for clk_period*10;
			end loop;
			
			-- Mi trovo in full_box, dopo questo colpo di clock l'automa evolve in:
			-- start, se il numero di scatole posizionate e' minore di 9,
			-- full_pallet, se il numero di scatole posizionate  pari a 9.
			-- Abbasso f perche' ho tolto la scatola
			f <= '0';
			wait for clk_period;
		end loop;
		
		-- L'automa e' in full_pallet
		wait for clk_period;
		
		-- Al prossimo colpo di clock l'automa passera' nello stato start
		continue <= '1';
		wait for clk_period;
		continue <= '0';
		wait for clk_period;
		
		-- Alzo il valore della fotocellula, al prossimo colpo di clock l'automa passera' nello stato waiting
		f <= '1';
		wait for clk_period;
		
		-- Verifico che con gli ingressi 00 ed 11 (p1 p0) l'automa non cambia stato
		p1 <= '0';
		p0 <= '0';
		wait for clk_period*5;
		p1 <= '1';
		p0 <= '1';
		wait for clk_period*5;
		
		-- Ora voglio verificare che il sistema non carica un oggetto di 2kg
		-- quando sono presenti gia' 3kg nella scatola
		-- Inizio col caricare 1 solo kg
		p1 <= '0';
		p0 <= '1';
		wait for clk_period;
		-- L'automa si trova nello stato loading, ne approfitto per verificare
		-- che l'automa non cambia stato con le possibili configurazioni di p1 p0
		p1 <= '0';
		p0 <= '0';
		wait for clk_period;
		p1 <= '0';
		p0 <= '1';
		wait for clk_period;
		p1 <= '1';
		p0 <= '0';
		wait for clk_period;
		p1 <= '1';
		p0 <= '1';
		wait for clk_period*7;
		
		-- Carico 2kg 
		p1 <= '1';
		p0 <= '0';
		wait for clk_period;
		p1 <= '0';
		wait for clk_period*10;
		-- dopo 10 colpi di clock l'automa si trova nello stato waiting,
		-- verifico che il sistema non carica gli oggetti di 2kg
		p1 <= '1';
		p0 <= '0';
		wait for clk_period*5;
		-- carico 1kg
		p1 <= '0';
		p0 <= '1';
		wait for clk_period;
		
		-- Non arrivano piu' oggetti
		p1 <= '0';
		p0 <= '0';
		
      wait;
   end process;

END;
