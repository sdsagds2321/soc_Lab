library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_pingpang is
-- Testbench 不需要端口
end tb_pingpang;

architecture Behavioral of tb_pingpang is

    -- 信號宣告，與待測模組 (DUT) 的介面保持一致
    signal i_rst   : std_logic := '0';
    signal i_clk   : std_logic := '0';
    signal i_btn_l : std_logic := '0';
    signal i_btn_r : std_logic := '0';
    signal o_led   : std_logic_vector(7 downto 0);

    -- 時鐘週期參數
    constant clk_period : time := 10 ns;

begin

    -- 實例化待測模組 (DUT)
    uut: entity work.pingpang
        port map (
            i_rst   => i_rst,
            i_clk   => i_clk,
            i_btn_l => i_btn_l,
            i_btn_r => i_btn_r,
            o_led   => o_led
        );

    -- 時鐘產生
    clk_gen: process
    begin
        while true loop
            i_clk <= '0';
            wait for clk_period / 2;
            i_clk <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    -- 測試過程
    test_process: process
    begin
        -- 初始狀態：復位
        i_rst <= '0';
        wait for clk_period * 5;  -- 等待一段時間
        i_rst <= '1';  -- 釋放復位

        -- 測試按鈕操作及 LED 移動
        wait for clk_period * 10;  -- 等待穩定
        i_btn_r <= '1';            -- 按下右側按鈕，開始遊戲
        wait for clk_period * 2;
        i_btn_r <= '0';

        -- 模擬 LED 移動到左側，左側按鈕擊球
        wait for clk_period * 100; -- 等待 LED 移動到左側
        i_btn_l <= '1';            -- 按下左側按鈕
        wait for clk_period * 2;
        i_btn_l <= '0';

        -- 模擬右側按鈕錯誤擊球，右側得分
        wait for clk_period * 100;
        i_btn_r <= '1';
        wait for clk_period * 2;
        i_btn_r <= '0';

        -- 模擬多次擊球，測試得分顯示
        for i in 0 to 15 loop
            wait for clk_period * 100; -- 等待一段時間
            if i mod 2 = 0 then
                i_btn_r <= '1';  -- 模擬右側按鈕擊球
                wait for clk_period * 2;
                i_btn_r <= '0';
            else
                i_btn_l <= '1';  -- 模擬左側按鈕擊球
                wait for clk_period * 2;
                i_btn_l <= '0';
            end if;
        end loop;

        -- 測試遊戲重置
        wait for clk_period * 100;
        i_rst <= '0'; -- 再次復位
        wait for clk_period * 5;
        i_rst <= '1';

        -- 測試結束
        wait;
    end process;

end Behavioral;
