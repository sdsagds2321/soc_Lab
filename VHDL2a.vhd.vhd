library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter_control is
    port(
        clk        : in  std_logic;  -- �ɯ�
        rst        : in  std_logic;  -- ���]
        mode       : in  std_logic;  -- �p�Ƥ�V����A'1'���[�ơA'0'�����
        upper_limit1 : in unsigned(3 downto 0); -- �p�ƾ�1�W��
        lower_limit1 : in unsigned(3 downto 0); -- �p�ƾ�1�U��
        upper_limit2 : in unsigned(3 downto 0); -- �p�ƾ�2�W��
        lower_limit2 : in unsigned(3 downto 0); -- �p�ƾ�2�U��
        counter1   : out unsigned(3 downto 0); -- �p�ƾ�1��X
        counter2   : out unsigned(3 downto 0)  -- �p�ƾ�2��X
    );
end counter_control;

architecture behavioral of counter_control is
    signal cnt1 : unsigned(3 downto 0) := "0000"; -- �p�ƾ�1�����T��
    signal cnt2 : unsigned(3 downto 0) := "0000"; -- �p�ƾ�2�����T��
begin
    -- �p�ƾ�1�޿�
    process(clk)
    begin
        if rst = '0' then
            cnt1 <= lower_limit1; -- �]�m���U����
        elsif rising_edge(clk) then
            if mode = '1' then  -- �[�ƼҦ�
                if cnt1 < upper_limit1 then
                    cnt1 <= cnt1 + 1;
                else
                    cnt1 <= lower_limit1; -- ��F�W���᭫�m��U��
                end if;
            else  -- ��ƼҦ�
                if cnt1 > lower_limit1 then
                    cnt1 <= cnt1 - 1;
                else
                    cnt1 <= upper_limit1; -- ��F�U���᭫�m��W��
                end if;
            end if;
        end if;
    end process;

    -- �p�ƾ�2�޿�
    process(clk)
    begin
        if rst = '0' then
            cnt2 <= lower_limit2; -- �]�m���U����
        elsif rising_edge(clk) then
            if mode = '1' then  -- �[�ƼҦ�
                if cnt2 < upper_limit2 then
                    cnt2 <= cnt2 + 1;
                else
                    cnt2 <= lower_limit2; -- ��F�W���᭫�m��U��
                end if;
            else  -- ��ƼҦ�
                if cnt2 > lower_limit2 then
                    cnt2 <= cnt2 - 1;
                else
                    cnt2 <= upper_limit2; -- ��F�U���᭫�m��W��
                end if;
            end if;
        end if;
    end process;

    -- ��X�T��
    counter1 <= cnt1;
    counter2 <= cnt2;
end behavioral;

