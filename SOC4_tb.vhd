library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Breathing_LED_tb is
-- 測試檔不需要端口
end Breathing_LED_tb;

architecture Behavioral of Breathing_LED_tb is

    -- 模擬輸入信號
    signal i_clk   : std_logic := '0';   -- 時鐘信號
    signal i_rst   : std_logic := '1';   -- 重置信號
    signal led_out : std_logic;          -- LED 輸出

    -- 時鐘週期參數 (調整為你的時鐘頻率)
    constant CLK_PERIOD : time := 10 ns;

begin

    -- **DUT (Device Under Test)**: 實例化你的模組
    DUT: entity work.Breathing_LED
        port map (
            i_clk   => i_clk,
            i_rst   => i_rst,
            led_out => led_out
        );

    -- **時鐘生成**: 創建時鐘信號
    process
    begin
        while true loop
            i_clk <= '0';
            wait for CLK_PERIOD / 2;
            i_clk <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
    end process;

    -- **重置信號生成**: 初始化重置
    process
    begin
        -- 保持 reset 高電平一段時間
        i_rst <= '1';
        wait for 100 ns;
        i_rst <= '0'; -- 釋放重置信號
        wait;
    end process;

    -- **模擬監控**: 查看信號變化
    process
    begin
        wait for 1 ms; -- 模擬一段時間
        report "Simulation completed";
        wait; -- 停止模擬
    end process;

end Behavioral;








