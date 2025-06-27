library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Breathing_LED_tb is
-- �����ɤ��ݭn�ݤf
end Breathing_LED_tb;

architecture Behavioral of Breathing_LED_tb is

    -- ������J�H��
    signal i_clk   : std_logic := '0';   -- �����H��
    signal i_rst   : std_logic := '1';   -- ���m�H��
    signal led_out : std_logic;          -- LED ��X

    -- �����g���Ѽ� (�վ㬰�A�������W�v)
    constant CLK_PERIOD : time := 10 ns;

begin

    -- **DUT (Device Under Test)**: ��ҤƧA���Ҳ�
    DUT: entity work.Breathing_LED
        port map (
            i_clk   => i_clk,
            i_rst   => i_rst,
            led_out => led_out
        );

    -- **�����ͦ�**: �Ыخ����H��
    process
    begin
        while true loop
            i_clk <= '0';
            wait for CLK_PERIOD / 2;
            i_clk <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
    end process;

    -- **���m�H���ͦ�**: ��l�ƭ��m
    process
    begin
        -- �O�� reset ���q���@�q�ɶ�
        i_rst <= '1';
        wait for 100 ns;
        i_rst <= '0'; -- ���񭫸m�H��
        wait;
    end process;

    -- **�����ʱ�**: �d�ݫH���ܤ�
    process
    begin
        wait for 1 ms; -- �����@�q�ɶ�
        report "Simulation completed";
        wait; -- �������
    end process;

end Behavioral;








