--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--   ____ ___   __    _               
--  / __// o |,'_/  .' \              
-- / _/ / _,'/ /_n / o /   _   __  _    ___  _   _  __
--/_/  /_/   |__,'/_n_/   / \,' /.' \ ,' _/,' \ / |/ /
--                       / \,' // o /_\ `./ o // || / 
--                      /_/ /_//_n_//___,'|_,'/_/|_/ 
-- 
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Author      : Wesley Taylor-Rendal (WTR)
-- Syntax      : VHDL-2008
-- Description : 
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

library ieee;
use ieee.std_logic_1164.all;
library cdc_lib;

entity tb_hdshk_pulse_sync is
end entity tb_hdshk_pulse_sync;


architecture tb of tb_hdshk_pulse_sync is

    signal clk_a           :  std_logic;
    signal sig_a           :  std_logic;
    signal clk_b           :  std_logic;
    signal sig_b           :  std_logic;
    signal busy            :  std_logic;
    constant clk_a_period  :  time := 15 ns;
    constant clk_b_period  :  time := 25 ns;

begin

    uut : entity cdc_lib.hdshk_pulse_sync
    port map
    (
        clk_a => clk_a,
        sig_a => sig_a,
        clk_b => clk_b,
        sig_b => sig_b,
        busy => busy
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
        procedure echo (arg : in string := "") is
        begin
              std.textio.write(std.textio.output, arg);
        end procedure echo;
    begin
        sig_a <= '0';

        for i in 1 to 100 loop
            wait until rising_edge(clk_a);
        end loop;

        echo("=========================\n");
        echo("Send 1 clk pulse \n"); -- haven't got time to fix this
        report "=========================";
        sig_a <= '1';
        wait until rising_edge(clk_a);
        sig_a <= '0';
        wait until busy='0';


        for i in 1 to 100 loop
            wait until rising_edge(clk_a);
        end loop;

        Report "=========================";
        Report "Send pulse and wait for busy";
        Report "      Proper use case       ";
        Report "=========================";
        sig_a <= '1';
        wait until busy='1';
        sig_a <= '0';
        wait until busy='0';

        for i in 1 to 100 loop
            wait until rising_edge(clk_a);
        end loop;

        Report "=========================";
        Report "Send pulse for arbitry clks";
        Report "          while            ";
        Report "paying no attention to busy";
        Report "=========================";
        sig_a <= '1';
        for i in 1 to 13 loop
            wait until rising_edge(clk_a);
        end loop;
        sig_a <= '0';
                                
        for i in 1 to 100 loop
            wait until rising_edge(clk_a);
        end loop;

        Report "=========================";
        Report "Toggle source pulse leavng";
        Report "1 Clock gap between ticks ";
        Report "=========================";
        sig_a <= '1';
        wait until rising_edge(clk_a);
        sig_a <= '0';
        wait until rising_edge(clk_a);
        wait until rising_edge(clk_a);
        sig_a <= '1';
        wait until rising_edge(clk_a);
        sig_a <= '0';
        wait until rising_edge(clk_a);
        wait until rising_edge(clk_a);
        sig_a <= '1';
        wait until rising_edge(clk_a);
        wait until rising_edge(clk_a);
        sig_a <= '0';
        wait until rising_edge(clk_a);

        for i in 1 to 100 loop
            wait until rising_edge(clk_a);
        end loop;
        report "End of simulation" severity failure; -- force sim termination
        wait;
    end process;


end architecture tb;
