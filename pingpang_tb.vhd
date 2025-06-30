library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_pingpang is
-- Testbench ���ݭn�ݤf
end tb_pingpang;

architecture Behavioral of tb_pingpang is

    -- �H���ŧi�A�P�ݴ��Ҳ� (DUT) �������O���@�P
    signal i_rst   : std_logic := '0';
    signal i_clk   : std_logic := '0';
    signal i_btn_l : std_logic := '0';
    signal i_btn_r : std_logic := '0';
    signal o_led   : std_logic_vector(7 downto 0);

    -- �����g���Ѽ�
    constant clk_period : time := 10 ns;

begin

    -- ��Ҥƫݴ��Ҳ� (DUT)
    uut: entity work.pingpang
        port map (
            i_rst   => i_rst,
            i_clk   => i_clk,
            i_btn_l => i_btn_l,
            i_btn_r => i_btn_r,
            o_led   => o_led
        );

    -- ��������
    clk_gen: process
    begin
        while true loop
            i_clk <= '0';
            wait for clk_period / 2;
            i_clk <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    -- ���չL�{
    test_process: process
    begin
        -- ��l���A�G�_��
        i_rst <= '0';
        wait for clk_period * 5;  -- ���ݤ@�q�ɶ�
        i_rst <= '1';  -- ����_��

        -- ���ի��s�ާ@�� LED ����
        wait for clk_period * 10;  -- ����í�w
        i_btn_r <= '1';            -- ���U�k�����s�A�}�l�C��
        wait for clk_period * 2;
        i_btn_r <= '0';

        -- ���� LED ���ʨ쥪���A�������s���y
        wait for clk_period * 100; -- ���� LED ���ʨ쥪��
        i_btn_l <= '1';            -- ���U�������s
        wait for clk_period * 2;
        i_btn_l <= '0';

        -- �����k�����s���~���y�A�k���o��
        wait for clk_period * 100;
        i_btn_r <= '1';
        wait for clk_period * 2;
        i_btn_r <= '0';

        -- �����h�����y�A���ձo�����
        for i in 0 to 15 loop
            wait for clk_period * 100; -- ���ݤ@�q�ɶ�
            if i mod 2 = 0 then
                i_btn_r <= '1';  -- �����k�����s���y
                wait for clk_period * 2;
                i_btn_r <= '0';
            else
                i_btn_l <= '1';  -- �����������s���y
                wait for clk_period * 2;
                i_btn_l <= '0';
            end if;
        end loop;

        -- ���չC�����m
        wait for clk_period * 100;
        i_rst <= '0'; -- �A���_��
        wait for clk_period * 5;
        i_rst <= '1';

        -- ���յ���
        wait;
    end process;

end Behavioral;
