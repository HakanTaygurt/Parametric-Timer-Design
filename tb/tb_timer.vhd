library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library vunit_lib;
context vunit_lib.vunit_context;

entity tb_timer is
    generic (
        runner_cfg    : string;
        clk_freq_hz_g : natural := 100_000_000;
        delay_us_g    : natural := 10
    );
end entity;

architecture tb of tb_timer is
    constant delay_g    : time := delay_us_g * 1 us;
    constant clk_period : time := 1 sec / clk_freq_hz_g;

    signal clk_i   : std_ulogic := '0';
    signal arst_i  : std_ulogic := '0';
    signal start_i : std_ulogic := '0';
    signal done_o  : std_ulogic;
begin
    DUT : entity work.timer
        generic map (
            clk_freq_hz_g => clk_freq_hz_g,
            delay_g       => delay_g
        )
        port map (
            clk_i   => clk_i,
            arst_i  => arst_i,
            start_i => start_i,
            done_o  => done_o
        );

    clk_process : process
    begin
        clk_i <= '0'; wait for clk_period / 2;
        clk_i <= '1'; wait for clk_period / 2;
    end process;

    main : process
        variable start_time, duration : time;
    begin
        test_runner_setup(runner, runner_cfg);

        arst_i <= '1'; wait for 10 * clk_period;
        arst_i <= '0'; wait for 2 * clk_period;
        check_equal(done_o, '1', "done_o should be 1 after reset");

        wait until rising_edge(clk_i);
        start_i <= '1';
        start_time := now;
        
        wait until rising_edge(clk_i);
        start_i <= '0';

        wait until rising_edge(done_o);
        duration := now - start_time;
        
        check(duration >= delay_g, "took less time than expected");
        check(duration < delay_g + 2 * clk_period, "took more time than expected");

        test_runner_cleanup(runner);
    end process;
end architecture;