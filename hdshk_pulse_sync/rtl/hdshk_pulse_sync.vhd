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
-- Description : A Handshake Pulse synchroniser provides an acknowledgement that
--             : a signal has passed from source to destination clock domain.
--             : Unfortunately 1 clk gap signals cannot be recognised.
--             : A busy signal is used to inform the source system about dest
--             : systems readiness.
--             : Shout out to 
--             :   https://www.youtube.com/watch?v=g4565qWOXF4
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
library ieee;
use ieee.std_logic_1164.all;
library cdc_lib;

entity hdshk_pulse_sync is
    port
    (
        clk_a  :  in  std_logic;
        sig_a  :  in  std_logic;
        clk_b  :  in  std_logic;
        sig_b  :  out std_logic;
        busy   :  out std_logic
    );
end entity hdshk_pulse_sync;

architecture rtl of hdshk_pulse_sync is


    --signal b1   : std_logic;
    signal b2   : std_logic := '0'; -- default on powerup (also lets the system set busy to '0' for sim)
    signal b3   : std_logic;
    signal a1   : std_logic := '0'; -- default on powerup (also lets the system set busy to '0' for sim)
    --signal a2   : std_logic;
    signal a3   : std_logic;
    signal mux1 : std_logic;
    signal mux2 : std_logic;

begin

    busy <= a3 OR a1;
    sig_b <= b2 and not b3;
    mux1 <= '0' when a3='1'    else a1;
    mux2 <= '1' when sig_a='1' else mux1;

    process(clk_b) is
    begin
        if rising_edge(clk_b) then
            --b1 <= a1;
            --b2 <= b1;
            b3 <= b2;
        end if;
    end process;

    process(clk_a) is
    begin
        if rising_edge(clk_a) then
            a1 <= mux2;
            --a2 <= b2;
            --a3 <= a1;
        end if;
    end process;

    b_sync : entity cdc_lib.ff_sync 
    generic map
    (
        pre_reg   => false,
        re_edge   => true,
        sync_size => 2
    )
    port map 
    (
        clk_a => '1', -- no pre-reg
        sig_a => a1,  -- A1 is held high for more than 1 b clock because of feeback.
        clk_b => clk_b,
        sig_b => b2
    );

    a_sync : entity cdc_lib.ff_sync 
    generic map
    (
        pre_reg   => false,
        re_edge   => true,
        sync_size => 2
    )
    port map 
    (
        clk_a => '1', -- no pre-reg
        sig_a => b2,  -- B2 is held high for more than 1 b clock because of feeback.
        clk_b => clk_a,
        sig_b => a3
    );

end architecture rtl;
