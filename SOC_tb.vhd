library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity two_counter_tb is
end two_counter_tb;

architecture Behavioral of two_counter_tb is

    -- Component declaration for the DUT (Device Under Test)
    component two_counter
        port (
            i_clk    : in std_logic;
            i_rst    : in std_logic;
            o_count1 : out std_logic_vector(3 downto 0);
            o_count2 : out std_logic_vector(3 downto 0)
        );
    end component;

    -- Signals to connect to the DUT
    signal i_clk    : std_logic := '0';
    signal i_rst    : std_logic := '0';
    signal o_count1 : std_logic_vector(3 downto 0);
    signal o_count2 : std_logic_vector(3 downto 0);

    -- Clock period constant
    constant clk_period : time := 10 ns;

begin

    -- Instantiate the DUT
    uut: two_counter
        port map (
            i_clk    => i_clk,
            i_rst    => i_rst,
            o_count1 => o_count1,
            o_count2 => o_count2
        );

    -- Clock generation process
    clk_process: process
    begin
        while true loop
            i_clk <= '0';
            wait for clk_period / 2;
            i_clk <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        -- Initialize reset
        i_rst <= '0';
        wait for 20 ns;
        i_rst <= '1';

        -- Allow the simulation to run for a while
        wait for 200 ns;

        -- Assert reset again
        i_rst <= '0';
        wait for 20 ns;
        i_rst <= '1';

        -- End simulation
        wait for 200 ns;
        assert false report "End of simulation" severity note;
        wait;
    end process;

end Behavioral;
