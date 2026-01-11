library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity timer is
    generic (
        clk_freq_hz_g : natural := 100_000_000;
        delay_g       : time    := 1 ms
    );
    port (
        clk_i   : in  std_ulogic;
        arst_i  : in  std_ulogic;
        start_i : in  std_ulogic;
        done_o  : out std_ulogic
    );
end entity timer;

architecture rtl of timer is
    
	-- First, we need to find the period of one clock cycle (10 ns)
    constant CLK_PERIOD : time := 1 sec / clk_freq_hz_g;
	
	
	--We need to find the exact cycle count by dividing the delay_g by period.
	--This method will help us find the exact value without loss.
    constant CYCLES_REQUIRED : natural := delay_g / CLK_PERIOD;

    signal counter_r : natural range 0 to CYCLES_REQUIRED;
    signal busy_r    : std_ulogic;

begin
    done_o <= not busy_r;

    process(clk_i, arst_i)
    begin
        if arst_i = '1' then
            busy_r    <= '0';
            counter_r <= 0;
        elsif rising_edge(clk_i) then
            if busy_r = '0' then
                if start_i = '1' then
                    busy_r    <= '1';
                    counter_r <= 0;
                end if;
            else
                -- counter limit control
                if counter_r < CYCLES_REQUIRED - 1 then
                    counter_r <= counter_r + 1;
                else
                    busy_r <= '0'; -- Time is up 
                end if;
            end if;
        end if;
    end process;
end architecture rtl;