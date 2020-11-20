--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--    ____ ___   __    _               
--   / __// o |,'_/  .' \              
--  / _/ / _,'/ /_n / o /   _   __  _    ___  _   _  __
-- /_/  /_/   |__,'/_n_/   / \,' /.' \ ,' _/,' \ / |/ /
--                        / \,' // o /_\ `./ o // || / 
--                       /_/ /_//_n_//___,'|_,'/_/|_/ 
-- 
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Author      : Wesley Taylor-Rendal (WTR)
-- Syntax      : VHDL-2008
-- Description : Testbench of ff_sync
--             : 1. From slower/same src clk domain to dest clk domain.
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
library ieee;
use	ieee.std_logic_1164.all;
library cdc_lib;

entity tb_ff_sync is
end entity tb_ff_sync;

architecture tb of tb_ff_sync is

	constant vec_size      :  integer := 4;
	constant clk_a_period  :  time := 25 ns;
	constant clk_b_period  :  time := 15 ns;
	signal clk_a           :  std_logic;
	signal clk_b           :  std_logic;
	signal sig_a           :  std_logic;
	signal sig_b           :  std_logic;

begin


    uut : entity cdc_lib.ff_sync 
    generic map
    (
        pre_reg   => true,
        re_edge   => true,
        sync_size => 2
    )
    port map 
    (
        clk_a => clk_a,
        sig_a => sig_a,
        clk_b => clk_b,
        sig_b => sig_b
    );


	gen_clk_a : process 
	begin
		clk_a <= '1';
		wait for clk_a_period/2;
		clk_a <= '0';
		wait for clk_a_period/2;
	end process;

	gen_clk_b : process 
	begin
		clk_b <= '1';
		wait for clk_b_period/2;
		clk_b <= '0';
		wait for clk_b_period/2;
	end process;

	stimulus : process
	begin
		sig_a <= '0';

		for i in 1 to 100 loop
			wait until rising_edge(clk_a);
		end loop;

		sig_a <= '1';

		for i in 1 to 100 loop
			wait until rising_edge(clk_a);
		end loop;

		sig_a <= '0';

		for i in 1 to 100 loop
			wait until rising_edge(clk_a);
		end loop;

		report "End of simulation" severity failure; -- force sim termination
		wait;
	end process;

end architecture tb;
