library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter_control is
    port(
        clk        : in  std_logic;  -- 
        rst        : in  std_logic;  -- 砞
        mode       : in  std_logic;  -- 璸计よ北'1'计'0'搭计
        upper_limit1 : in unsigned(3 downto 0); -- 璸计竟1
        lower_limit1 : in unsigned(3 downto 0); -- 璸计竟1
        upper_limit2 : in unsigned(3 downto 0); -- 璸计竟2
        lower_limit2 : in unsigned(3 downto 0); -- 璸计竟2
        counter1   : out unsigned(3 downto 0); -- 璸计竟1块
        counter2   : out unsigned(3 downto 0)  -- 璸计竟2块
    );
end counter_control;

architecture behavioral of counter_control is
    signal cnt1 : unsigned(3 downto 0) := "0000"; -- 璸计竟1ず场癟腹
    signal cnt2 : unsigned(3 downto 0) := "0000"; -- 璸计竟2ず场癟腹
begin
    -- 璸计竟1呸胯
    process(clk)
    begin
        if rst = '0' then
            cnt1 <= lower_limit1; -- 砞竚
        elsif rising_edge(clk) then
            if mode = '1' then  -- 计家Α
                if cnt1 < upper_limit1 then
                    cnt1 <= cnt1 + 1;
                else
                    cnt1 <= lower_limit1; -- 笷竚
                end if;
            else  -- 搭计家Α
                if cnt1 > lower_limit1 then
                    cnt1 <= cnt1 - 1;
                else
                    cnt1 <= upper_limit1; -- 笷竚
                end if;
            end if;
        end if;
    end process;

    -- 璸计竟2呸胯
    process(clk)
    begin
        if rst = '0' then
            cnt2 <= lower_limit2; -- 砞竚
        elsif rising_edge(clk) then
            if mode = '1' then  -- 计家Α
                if cnt2 < upper_limit2 then
                    cnt2 <= cnt2 + 1;
                else
                    cnt2 <= lower_limit2; -- 笷竚
                end if;
            else  -- 搭计家Α
                if cnt2 > lower_limit2 then
                    cnt2 <= cnt2 - 1;
                else
                    cnt2 <= upper_limit2; -- 笷竚
                end if;
            end if;
        end if;
    end process;

    -- 块癟腹
    counter1 <= cnt1;
    counter2 <= cnt2;
end behavioral;

