library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Breathing_LED is
    Port (
        i_clk     : in  STD_LOGIC;  -- 時鐘輸入
        i_rst     : in  STD_LOGIC;  -- 重置信號
        led_out : out STD_LOGIC   -- LED 輸出
    );
end Breathing_LED;

architecture Behavioral of Breathing_LED is
    signal pwm_counter : unsigned(7 downto 0) := (others => '0'); -- PWM 計數器 (範圍 0~255)
    signal brightness  : unsigned(7 downto 0) := (others => '0'); -- 亮度值 (範圍 0~255)
    signal direction   : STD_LOGIC := '1'; -- 方向：'1' = 漸亮, '0' = 漸暗
    signal clk_div     : unsigned(20 downto 0) := (others => '0'); -- 分頻計數器
    signal slow_clk    : STD_LOGIC := '0'; -- 慢速時鐘
begin

    -- **時鐘分頻**: 生成慢速時鐘
    process(i_clk, i_rst)
    begin
        if i_rst = '1' then
            clk_div <= (others => '0');
            slow_clk <= '0';
        elsif rising_edge(i_clk) then
            clk_div <= clk_div + 1;
            slow_clk <= clk_div(1); -- 控制呼吸燈變化速度 (調整位元寬度來加速或減速)
        end if;
    end process;

    -- **亮度控制**: 自動漸亮和漸暗
    process(slow_clk, i_rst)
    begin
        if i_rst = '1' then
            brightness <= (others => '0'); -- 初始化亮度為 0 (二進制: 00000000)
            direction <= '1'; -- 初始為漸亮
        elsif rising_edge(slow_clk) then
            if direction = '1' then -- 漸亮
                if brightness = "11111111" then  -- 當亮度達到最大值 (二進制: 11111111)
                    direction <= '0'; -- 切換為漸暗
                else
                    brightness <= brightness + 1; -- 增加亮度
                end if;
            else -- 漸暗
                if brightness = "00000000" then  -- 當亮度達到最小值 (二進制: 00000000)
                    direction <= '1'; -- 切換為漸亮
                else
                    brightness <= brightness - 1; -- 減少亮度
                end if;
            end if;
        end if;
    end process;

    -- **PWM 產生**: 根據亮度值生成 PWM 信號
    process(i_clk, i_rst)
    begin
        if i_rst = '1' then
            pwm_counter <= (others => '0');
            led_out <= '0';
        elsif rising_edge(i_clk) then
            pwm_counter <= pwm_counter + 1;
            if pwm_counter < brightness then
                led_out <= '1'; -- 開啟 LED
            else
                led_out <= '0'; -- 關閉 LED
            end if;
        end if;
    end process;

end Behavioral;









