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
-- Description : Toggle sync is used to synchronise a pulse generating in source
--             : clock to dest clock, when source is faster.
--             : Generics explained => 
--             :    re_edge is used to capture on rising or falling edge
--             :    sync_size determines how many ff in the source domain are required.
--             : N.B Place edge_detector after to propagate a pulse in dest.
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
library ieee;
use	ieee.std_logic_1164.all;

entity toggle_sync is
    generic
    (
        re_edge   : boolean := true;
        sync_size : integer := 3
    );
    port 
    (
        clk_a : in  std_logic;
        sig_a : in  std_logic;
        clk_b : in  std_logic;
        sig_b : out std_logic
    );
end entity toggle_sync;

architecture rtl of toggle_sync is


    signal fast_event  : std_logic;
    signal q           : std_logic := '0';

    type sig_b_array_t is array (sync_size-1 downto 0) of std_logic;
    signal capture_reg : std_logic_vector(sync_size-1 downto 0);

begin

    -- Combinational logic
    fast_event <= not q when sig_a='1' else q;

    sig_b <= capture_reg(sync_size-1) xor capture_reg(sync_size-2);

    -- Detect toggle
    fast_clk : process (clk_a) is
    begin
        if re_edge then 
            if rising_edge(clk_a) then
                q <= fast_event;
            end if;
        else
            if falling_edge(clk_a) then
                q <= fast_event;
            end if;
        end if;
    end process;

    slow_clk : process(clk_b) is
    begin
        if re_edge then
            if rising_edge(clk_b) then
                capture_reg <= capture_reg(sync_size-2 downto 0) & q;
            end if;
        else
            if falling_edge(clk_b) then
                capture_reg <= capture_reg(sync_size-2 downto 0) & q;
            end if;
        end if;
    end process;

end architecture rtl;
