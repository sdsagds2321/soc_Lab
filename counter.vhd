library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity counter is
    Port ( i_clk    : in  STD_LOGIC;
           i_rst    : in  STD_LOGIC;
           o_count1 : out STD_LOGIC_VECTOR (7 downto 0);
           o_count2 : out STD_LOGIC_VECTOR (7 downto 0);
           o_count3 : out STD_LOGIC_VECTOR (7 downto 0)
           );
end counter;

architecture Behavioral of counter is
    signal count1 : STD_LOGIC_VECTOR(7 downto 0);
    signal count2 : STD_LOGIC_VECTOR(7 downto 0);
    signal count3 : STD_LOGIC_VECTOR(7 downto 0);
    type FSM_STATE is (s0, s1, s2, s3);
    signal state : FSM_STATE;
begin
    o_count1 <= count1;
    o_count2 <= count2;
    o_count3 <= count3;

    -- FSM process
    FSM:process(i_clk, i_rst)
    begin
        if i_rst = '0' then
            state <= s0; -- 重置狀態
        elsif rising_edge(i_clk) then
            case state is
                when s0 =>
                    if count1 = "00001000" then -- 當 count1 達到 8
                        state <= s2; -- 切換到 s2
                    end if;
                when s1 =>
                    if count2 = "01010000" then -- 當 count2 達到 80
                        state <= s3; -- 切換到 s3
                    end if;
                when s2 =>
                    if count3 = "00001010" then -- 當 count3 達到 10
                        state <= s1; -- 切換到 s1
                    end if;
                when s3 =>
                    state <= s0; -- 切換到 s0
                when others =>
                    null;
            end case;
        end if;
    end process;

    -- Counter1 process
    counter1:process(i_clk, i_rst)
    begin
        if i_rst = '0' then
            count1 <= (others => '0'); -- 重置計數器
        elsif rising_edge(i_clk) then
            case state is
                when s0 =>
                    if count1 < "11111101" then -- 限制最大值為 253
                        count1 <= count1 + 1; -- 正常加法
                    else
                        count1 <= count1; -- 停止加法
                    end if;
                when s2 =>
                    count1 <= (others => '0'); -- 重置計數器
                when others =>
                    null;
            end case;
        end if;
    end process;

    -- Counter2 process
    counter2:process(i_clk, i_rst)
    begin
        if i_rst = '0' then
            count2 <= "11111101"; -- 初始化為253
        elsif rising_edge(i_clk) then
            case state is
                when s3 =>
                    count2 <= "11111101"; -- 重置為253而不是254
                when s1 =>
                    if count2 > "00000000" then -- 限制最小值為 0
                        count2 <= count2 - 1; -- 正常減法
                    else
                        count2 <= count2; -- 停止減法
                    end if;
                when others =>
                    null;
            end case;
        end if;
    end process;

    -- Counter3 process
    counter3:process(i_clk, i_rst)
    begin
        if i_rst = '0' then
            count3 <= (others => '0'); -- 重置計數器
        elsif rising_edge(i_clk) then
            case state is
                when s2 =>
                    if count3 < "11111101" then -- 限制最大值為 253
                        count3 <= count3 + 1; -- 正常加法
                    else
                        count3 <= count3; -- 停止加法
                    end if;
                when s0 =>
                    count3 <= (others => '0'); -- 重置計數器
                when others =>
                    null;
            end case;
        end if;
    end process;

end Behavioral;