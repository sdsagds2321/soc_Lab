library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity pingpang_serial_tb is
end entity;

architecture Behavioral of pingpang_serial_tb is

    -- Test signals
    signal clk      : std_logic := '0';
    signal rst      : std_logic := '0';
    signal btn_A    : std_logic := '0';
    signal btn_B    : std_logic := '0';
    signal check_A  : std_logic := '0';
    signal check_B  : std_logic := '0';
    signal gpio_wire: std_logic := 'Z';

    -- LED output (for observation)
    signal led_A    : std_logic_vector(7 downto 0);
    signal led_B    : std_logic_vector(7 downto 0);

begin

    -- Clock generation
    clk_process: process
    begin
        clk <= not clk;
        wait for 10 ns;
    end process;

    -- Instantiate UUT A
    UUT_A: entity work.pingpang_serial
        port map (
            i_clk   => clk,
            i_rst   => rst,
            i_btn   => btn_A,
            io_gpio => gpio_wire,
            i_check => check_A,
            o_led   => led_A
        );

    -- Instantiate UUT B
    UUT_B: entity work.pingpang_serial
        port map (
            i_clk   => clk,
            i_rst   => rst,
            i_btn   => btn_B,
            io_gpio => gpio_wire,
            i_check => check_B,
            o_led   => led_B
        );

    -- Main simulation process
    process
    begin
        -- Global reset
        rst <= '1';
        wait for 50 ns;
        rst <= '0';
        wait for 200 ns;

        -- === Test 1: Normal rally: A serve, B returns ===
        btn_A <= '1'; wait for 20 ns; btn_A <= '0';
        wait for 2000 ns;
        btn_B <= '1'; wait for 20 ns; btn_B <= '0';
        wait for 2000 ns;

        -- === Test 2: B misses (no button press) ===
        btn_A <= '1'; wait for 20 ns; btn_A <= '0';
        wait for 2500 ns;

        -- === Test 3: Early hit: B hits too early ===
        btn_A <= '1'; wait for 20 ns; btn_A <= '0';
        wait for 100 ns; btn_B <= '1'; wait for 20 ns; btn_B <= '0';
        wait for 2000 ns;

        -- === Test 4: Several normal rallies ===
        btn_A <= '1'; wait for 20 ns; btn_A <= '0';
        wait for 2000 ns; btn_B <= '1'; wait for 20 ns; btn_B <= '0';
        wait for 2000 ns; btn_A <= '1'; wait for 20 ns; btn_A <= '0';
        wait for 2000 ns; btn_B <= '1'; wait for 20 ns; btn_B <= '0';
        wait for 2000 ns;
 -- === Test 5: B 在 MOVE_L 左移中太早按，應該造成失誤回初始 ===
        btn_A <= '1'; wait for 20 ns; btn_A <= '0';         -- A 發球
        wait for 1500 ns;  -- 保證已進入 MOVE_L 狀態但還沒到 LED5（可打區）
        btn_B <= '1'; wait for 20 ns; btn_B <= '0';         -- B 提早按
        wait for 2500 ns;
        wait;
    end process;

end Behavioral;
