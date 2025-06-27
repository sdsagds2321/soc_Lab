library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_counter_control is
-- Testbench �S����~���s����
end tb_counter_control;

architecture behavioral of tb_counter_control is
    -- ����ŧi
    component counter_control
        port(
            clk         : in  std_logic;
            rst         : in  std_logic;
            mode        : in  std_logic;
            upper_limit1 : in unsigned(3 downto 0);
            lower_limit1 : in unsigned(3 downto 0);
            upper_limit2 : in unsigned(3 downto 0);
            lower_limit2 : in unsigned(3 downto 0);
            counter1    : out unsigned(3 downto 0);
            counter2    : out unsigned(3 downto 0)
        );
    end component;

    -- ���հT���ŧi
    signal clk         : std_logic := '0';
    signal rst         : std_logic := '0';
    signal mode        : std_logic := '1';  -- �w�]�[�ƼҦ�
    signal upper_limit1 : unsigned(3 downto 0) := "1111"; -- �p�ƾ�1�W��
    signal lower_limit1 : unsigned(3 downto 0) := "0001"; -- �p�ƾ�1�U��
    signal upper_limit2 : unsigned(3 downto 0) := "0110"; -- �p�ƾ�2�W��
    signal lower_limit2 : unsigned(3 downto 0) := "0010"; -- �p�ƾ�2�U��
    signal counter1    : unsigned(3 downto 0);
    signal counter2    : unsigned(3 downto 0);

    -- �ɯߥͦ��G�C10 ns �����@��
    constant clk_period : time := 10 ns;

begin
    -- �Ҥƭp�ƾ�����
    uut: counter_control
        port map(
            clk         => clk,
            rst         => rst,
            mode        => mode,
            upper_limit1 => upper_limit1,
            lower_limit1 => lower_limit1,
            upper_limit2 => upper_limit2,
            lower_limit2 => lower_limit2,
            counter1    => counter1,
            counter2    => counter2
        );

    -- �ɯߥͦ��{��
    clk_process: process
    begin
        while true loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    -- ���լy�{
    test_process: process
    begin
        -- ��l���]
        rst <= '1';  -- �������]
        wait for 20 ns;
        rst <= '0';  -- ���]�Ұ�
        wait for 20 ns;
        rst <= '1';  -- ���񭫳]

        -- ��l�ƼҦ����[�ƼҦ�
       mode <= '1'; -- �]�w���[�ƼҦ�

-- ����100 ns�A�������ƼҦ�
       wait for 120 ns;
       mode <= '0'; -- �אּ��ƼҦ�

-- �A����100 ns�A���^�[�ƼҦ�
      wait for 120 ns;
      mode <= '1';


        -- ��������
        wait;
    end process;
end behavioral;

