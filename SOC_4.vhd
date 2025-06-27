library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Breathing_LED is
    Port (
        i_clk     : in  STD_LOGIC;  -- ������J
        i_rst     : in  STD_LOGIC;  -- ���m�H��
        led_out : out STD_LOGIC   -- LED ��X
    );
end Breathing_LED;

architecture Behavioral of Breathing_LED is
    signal pwm_counter : unsigned(7 downto 0) := (others => '0'); -- PWM �p�ƾ� (�d�� 0~255)
    signal brightness  : unsigned(7 downto 0) := (others => '0'); -- �G�׭� (�d�� 0~255)
    signal direction   : STD_LOGIC := '1'; -- ��V�G'1' = ���G, '0' = ���t
    signal clk_div     : unsigned(20 downto 0) := (others => '0'); -- ���W�p�ƾ�
    signal slow_clk    : STD_LOGIC := '0'; -- �C�t����
begin

    -- **�������W**: �ͦ��C�t����
    process(i_clk, i_rst)
    begin
        if i_rst = '1' then
            clk_div <= (others => '0');
            slow_clk <= '0';
        elsif rising_edge(i_clk) then
            clk_div <= clk_div + 1;
            slow_clk <= clk_div(1); -- ����I�l�O�ܤƳt�� (�վ�줸�e�רӥ[�t�δ�t)
        end if;
    end process;

    -- **�G�ױ���**: �۰ʺ��G�M���t
    process(slow_clk, i_rst)
    begin
        if i_rst = '1' then
            brightness <= (others => '0'); -- ��l�ƫG�׬� 0 (�G�i��: 00000000)
            direction <= '1'; -- ��l�����G
        elsif rising_edge(slow_clk) then
            if direction = '1' then -- ���G
                if brightness = "11111111" then  -- ��G�׹F��̤j�� (�G�i��: 11111111)
                    direction <= '0'; -- ���������t
                else
                    brightness <= brightness + 1; -- �W�[�G��
                end if;
            else -- ���t
                if brightness = "00000000" then  -- ��G�׹F��̤p�� (�G�i��: 00000000)
                    direction <= '1'; -- ���������G
                else
                    brightness <= brightness - 1; -- ��֫G��
                end if;
            end if;
        end if;
    end process;

    -- **PWM ����**: �ھګG�׭ȥͦ� PWM �H��
    process(i_clk, i_rst)
    begin
        if i_rst = '1' then
            pwm_counter <= (others => '0');
            led_out <= '0';
        elsif rising_edge(i_clk) then
            pwm_counter <= pwm_counter + 1;
            if pwm_counter < brightness then
                led_out <= '1'; -- �}�� LED
            else
                led_out <= '0'; -- ���� LED
            end if;
        end if;
    end process;

end Behavioral;









