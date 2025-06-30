library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity pp_game is
    port (
                i_clk      : IN STD_LOGIC;              -- 100MHz������J
		        i_rst      : IN STD_LOGIC;              -- ���m�H��
		        i_sw_l     : IN STD_LOGIC;
		        i_sw_r     : IN STD_LOGIC;
                o_red      : OUT STD_LOGIC_VECTOR(3 downto 0);  -- ����H����X
                o_green    : OUT STD_LOGIC_VECTOR(3 downto 0);  -- ���H����X
                o_blue     : OUT STD_LOGIC_VECTOR(3 downto 0);  -- �Ŧ�H����X
                h_sync   : OUT STD_LOGIC;             -- �����P�B�H����X
                v_sync   : OUT STD_LOGIC              -- �����P�B�H����X
    );
end pp_game;

architecture Behavioral of pp_game is
component VGA  --VGA �O�A�ۤv�t�~�]�p���@�ӼҲաA�ΨӲ��͹Ϲ��C
     generic(
                H_RES     : INTEGER  := 800;
                H_FP      : INTEGER  := 56;
                H_SYNC    : INTEGER  := 120;
                H_BP      : INTEGER  := 64;
                H_POL     : STD_LOGIC := '1';
	
                V_RES     : INTEGER  := 600;
                V_FP      : INTEGER  := 37;
                V_SYNC    : INTEGER  := 6;
                V_BP      : INTEGER  := 23;
                V_POL     : STD_LOGIC := '1'
    );
     port (
                i_clk      : IN STD_LOGIC;              -- 100MHz������J
		        i_rst      : IN STD_LOGIC;              -- ���m�H��
                o_red      : OUT STD_LOGIC_VECTOR(3 downto 0);  -- ����H����X
                o_green    : OUT STD_LOGIC_VECTOR(3 downto 0);  -- ���H����X
                o_blue     : OUT STD_LOGIC_VECTOR(3 downto 0);  -- �Ŧ�H����X
                o_h_sync   : OUT STD_LOGIC;             -- �����P�B�H����X
                o_v_sync   : OUT STD_LOGIC;              -- �����P�B�H����X
                bar_l_x    : IN INTEGER;
                bar_l_y    : IN INTEGER;
                bar_r_x    : IN INTEGER;
                bar_r_y    : IN INTEGER;
                circle_center_x : IN INTEGER;
                circle_center_y : IN INTEGER
    );
end component;

signal bar_l_x    : INTEGER := 0;
signal bar_l_y    : INTEGER RANGE 0 TO 480 := 0;
signal bar_r_x    : INTEGER := 785;
signal bar_r_y    : INTEGER RANGE 0 TO 480 := 0;
signal bar_dy     : INTEGER := 10;
signal circle_center_x : INTEGER RANGE -10 TO 800 := 0;
signal circle_center_y : INTEGER RANGE -10 TO 600 := 0;
signal ball_dx    : INTEGER := 2;
signal ball_dy    : INTEGER := 2;
signal ball_state : std_logic_vector (1 downto 0);
signal div_clk    : std_logic := '0';
signal counter    : std_logic_vector(24 downto 0);
constant BALL_RADIUS : INTEGER := 10;

begin
    -- ���t���� div_clk
    process (i_clk, i_rst)
    begin
        if i_rst = '1' then
            counter <= (others => '0');
            div_clk <= '0';
        elsif rising_edge(i_clk) then
            counter <= counter + 1;
            div_clk <= counter(20);  -- �վ�t�ץ�
        end if;
    end process;
    
    -- �y�精�ʱ���
    process(i_clk, div_clk, i_rst)
    begin
        if i_rst = '1' then
            bar_r_y <= 0;
        elsif rising_edge(div_clk) then
            -- �k��y��
            if (i_sw_r = '1' and bar_r_y < 480) then
                bar_r_y <= bar_r_y + bar_dy;
            elsif (i_sw_r = '0' and bar_r_y > 0) then
                bar_r_y <= bar_r_y - bar_dy;
            end if;

            -- ����y��
            if (i_sw_l = '1' and bar_l_y < 480) then
                bar_l_y <= bar_l_y + bar_dy;
            elsif (i_sw_l = '0' and bar_l_y > 0) then
                bar_l_y <= bar_l_y - bar_dy;
            end if;
        end if;
    end process;

    -- �y���� & ��ɸI���޿�]�]�A�y��ϼu�^
    -- �y���� & ��ɸI���޿�]�]�A�y��ϼu�^
process(i_clk, i_rst, div_clk)
begin
    if i_rst = '1' then
        ball_dx <= 2;
        ball_dy <= 2;
        circle_center_x <= 400;  -- �������s�}�l
        circle_center_y <= 300;  -- �������s�}�l
        ball_state <= "11";  -- ��l���A
    elsif rising_edge(div_clk) then    
        case ball_state is
            when "00" =>  -- �k�U
                circle_center_x <= circle_center_x + ball_dx;
                circle_center_y <= circle_center_y + ball_dy;

                if (circle_center_y + BALL_RADIUS) >= 600 then
                    ball_state <= "01";  
                elsif (circle_center_x + BALL_RADIUS) >= bar_r_x and
                      circle_center_y >= bar_r_y and 
                      circle_center_y <= bar_r_y + 100 then
                    ball_state <= "10";  -- �I�k��y��ϼu
                elsif (circle_center_x + BALL_RADIUS) >= 800 then
                    -- �y�I��k����A���s�}�l
                    circle_center_x <= 400;  -- ���m�줤��
                    circle_center_y <= 300;  -- ���m�줤��
                    ball_state <= "11";  -- ��l���A
                end if;

            when "01" =>  -- �k�W
                circle_center_x <= circle_center_x + ball_dx;
                circle_center_y <= circle_center_y - ball_dy;

                if (circle_center_y - BALL_RADIUS) <= 0 then
                    ball_state <= "00";  
                elsif (circle_center_x + BALL_RADIUS) >= bar_r_x and
                      circle_center_y >= bar_r_y and 
                      circle_center_y <= bar_r_y + 100 then
                    ball_state <= "11";  -- �I�k��y��ϼu
                elsif (circle_center_x + BALL_RADIUS) >= 800 then
                    -- �y�I��k����A���s�}�l
                    circle_center_x <= 400;  -- ���m�줤��
                    circle_center_y <= 300;  -- ���m�줤��
                    ball_state <= "11";  -- ��l���A
                end if;

            when "10" =>  -- ���U
                circle_center_x <= circle_center_x - ball_dx;
                circle_center_y <= circle_center_y + ball_dy;

                if (circle_center_y + BALL_RADIUS) >= 600 then
                    ball_state <= "11";  
                elsif (circle_center_x - BALL_RADIUS) <= bar_l_x + 15 and
                      circle_center_y >= bar_l_y and 
                      circle_center_y <= bar_l_y + 100 then
                    ball_state <= "00";  -- �I����y��ϼu
                elsif (circle_center_x - BALL_RADIUS) <= 0 then
                    -- �y�I�쥪����A���s�}�l
                    circle_center_x <= 400;  -- ���m�줤��
                    circle_center_y <= 300;  -- ���m�줤��
                    ball_state <= "01";  -- ��l���A
                end if;

            when "11" =>  -- ���W
                circle_center_x <= circle_center_x - ball_dx;
                circle_center_y <= circle_center_y - ball_dy;

                if (circle_center_x - BALL_RADIUS) <= bar_l_x + 15 and
                      circle_center_y >= bar_l_y and 
                      circle_center_y <= bar_l_y + 100 then
                    ball_state <= "01";  -- �I����y��ϼu
                elsif (circle_center_y - BALL_RADIUS) <= 0 then
                    ball_state <= "10";  
                elsif (circle_center_x - BALL_RADIUS) <= 0 then
                    -- �y�I�쥪����A���s�}�l
                    circle_center_x <= 400;  -- ���m�줤��
                    circle_center_y <= 300;  -- ���m�줤��
                    ball_state <= "00";  -- ��l���A
                end if;

            when others =>
                -- �S�ܤ�
                circle_center_x <= circle_center_x;
                circle_center_y <= circle_center_y;
        end case;
    end if;
end process;



    -- VGA �����
    VGA_inst : VGA
        PORT MAP (
            i_clk        => i_clk,
            i_rst        => i_rst,
            bar_r_x      => bar_r_x,
            bar_r_y      => bar_r_y,
            bar_l_x      => bar_l_x,
            bar_l_y      => bar_l_y,
            circle_center_x => circle_center_x,
            circle_center_y => circle_center_y,
            o_red        => o_red , 
            o_green      => o_green,
            o_blue       => o_blue ,
            o_h_sync     => h_sync,
            o_v_sync     => v_sync
        );
end Behavioral;


