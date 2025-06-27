library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity pingpang_tb is
end pingpang_tb;

architecture Behavioral of pingpang_tb is

    -- Testbench signals
    signal tb_rst     : std_logic := '0';
    signal tb_clk     : std_logic := '0';
    signal tb_btn_l   : std_logic := '0';
    signal tb_btn_r   : std_logic := '0';
    signal tb_led     : std_logic_vector(7 downto 0);

    -- Clock period
    constant clk_period : time := 1us;

begin

    -- Instantiate the table_tennis module
    uut: entity work.pingpang
        port map (
            i_rst  => tb_rst,
            i_clk  => tb_clk,
            i_btn_l => tb_btn_l,
            i_btn_r => tb_btn_r,
            o_led  => tb_led
        );

    -- Clock generation
    tb_clk_process: process
    begin
        while true loop
            tb_clk <= '0';
            wait for clk_period / 2;
            tb_clk <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    -- Stimulus process
    stimulus: process
    begin
        -- Reset system
        tb_rst <= '0';
        wait for clk_period;
        tb_rst <= '1';
        wait for clk_period;

        -- Test right move
        tb_btn_r <= '1';
        wait for clk_period * 8;  -- Simulate button press duration

        tb_btn_r <= '0';
        wait for clk_period * 0.5;  -- Observe the result
        tb_btn_l <= '1';
        wait for clk_period * 8;  -- Simulate button press duration


        -- Test left move

        tb_btn_l <= '0';
        wait for clk_period * 4;  -- Observe the result

        -- Test reset and restart
        tb_rst <= '0';
        wait for clk_period;
        tb_rst <= '1';
        wait for clk_period * 4;

        -- End simulation
        wait;
    end process;

end Behavioral;
