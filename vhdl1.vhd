library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL; 
use IEEE.STD_LOGIC_UNSIGNED.ALL; 

entity counter_0_to_9 is
    Port ( i_clk    : in  STD_LOGIC;
           i_reset  : in  STD_LOGIC;
           o_count  : out STD_LOGIC_VECTOR(3 downto 0)
           );
end counter_0_to_9;

architecture Behavioral of counter_0_to_9 is
    signal counter_24 : STD_LOGIC_VECTOR(23 downto 0) := (others => '0');
    signal clk_seg    : STD_LOGIC := '0';  -- �ΨӤ��W���H��
    signal counter    : STD_LOGIC_VECTOR(3 downto 0) := "0000";  -- 4�줸�p�ƾ�
    signal up_down    : STD_LOGIC := '1';  -- ����p�Ƥ�V
begin
    -- ���W���G�C�� counter_24 �p�ƨ�S�w�ȮɡA�]�m clk_seg ����
    process (i_clk, i_reset)
    begin
        if i_reset = '1' then
            counter_24 <= (others => '0');
            clk_seg <= '0';
        elsif rising_edge(i_clk) then
            counter_24 <= counter_24 + 1;
            if counter_24 = "101111101000000000000000" then  -- �]�m���W�� (�Ҧp�G�p�ƨ�Y�ӭ�)
                clk_seg <= not clk_seg;
                counter_24 <= (others => '0');  -- ���m���W�p�ƾ�
            end if;
        end if;
    end process;

    -- �p�ƾ�����G�ھ� clk_seg �i��W�U�p��
    process(i_clk, i_reset)
    begin
        if i_reset = '1' then
            counter <= "0000";  -- ��l��0
            up_down <= '1';     -- ��l���V�W�p��
        elsif rising_edge(clk_seg) then  -- �ϥ� clk_seg �@���p�Ʈ���
            if up_down = '1' then
                if counter = "1001" then
                    up_down <= '0';  -- �F��9�ɶ}�l�V�U�p��
                else
                    counter <= counter + 1;
                end if;
            else
                if counter = "0000" then
                    up_down <= '1';  -- �F��0�ɶ}�l�V�W�p��
                else
                    counter <= counter - 1;
                end if;
            end if;
        end if;
    end process;

    -- ��X�p�ƾ�����
    o_count <= counter;

end Behavioral;









