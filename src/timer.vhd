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
    
    -- Calculate the period of a single clock cycle
    constant CLK_PERIOD : time := 1 sec / clk_freq_hz_g;
    
    -- Calculate the exact number of cycles required for the delay
    constant CYCLES_REQUIRED : natural := delay_g / CLK_PERIOD;
    
    signal counter_r : natural range 0 to CYCLES_REQUIRED;
    signal busy_r    : std_ulogic;
    
begin
    -- Output assignment: done is high when the timer is NOT busy
    done_o <= not busy_r;

    process(clk_i, arst_i)
    begin
        if arst_i = '1' then
            busy_r    <= '0';
            counter_r <= 0;
        elsif rising_edge(clk_i) then
            if busy_r = '0' then
                -- IDLE STATE: Wait for start pulse
                if start_i = '1' then
                    busy_r    <= '1';
                    counter_r <= 0;
                end if;
            else
                -- BUSY STATE: Count until the limit is reached
                if counter_r < CYCLES_REQUIRED - 1 then
                    counter_r <= counter_r + 1;
                else
                    busy_r <= '0'; -- Timer finished
                end if;
            end if;
        end if;
    end process;

    -- =========================================================================
    -- FORMAL VERIFICATION (PSL - Property Specification Language)
    -- =========================================================================
    -- The following block is ignored by synthesis tools but read by formal
    -- verification tools like SymbiYosys (SBY).
    --
    -- synthesis translate_off
    
    -- psl default clock is rising_edge(clk_i);

    -- PROPERTY 1: RESET CHECK
    -- When reset is asserted, the module must immediately go to IDLE state (done='1').
    -- psl ASSERT_RESET: assert always (arst_i = '1' -> done_o = '1');

    -- PROPERTY 2: BUSY INDICATOR
    -- When the internal busy flag is high, the done output must be low.
    -- psl ASSERT_BUSY: assert always (busy_r = '1' -> done_o = '0');

    -- PROPERTY 3: FUNCTIONAL CORRECTNESS (SEQUENCE)
    -- If a start signal is received (while idle and not in reset), 
    -- the output 'done_o' must remain '0' for exactly CYCLES_REQUIRED cycles,
    -- and then become '1' in the following cycle.
    --
    -- Notation: [*N] means repeat N times; |=> means "next cycle implies".
    
    -- psl SEQUENCE_CHECK: assert always (
    --    (start_i = '1' and busy_r = '0' and arst_i = '0') -> 
    --    next (
    --       (done_o = '0') [*CYCLES_REQUIRED] ; 
    --       (done_o = '1')
    --    )
    -- );

    -- synthesis translate_on
    -- =========================================================================

end architecture rtl;