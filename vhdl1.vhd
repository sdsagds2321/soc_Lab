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
    signal clk_seg    : STD_LOGIC := '0';  -- ノㄓだ繵獺腹
    signal counter    : STD_LOGIC_VECTOR(3 downto 0) := "0000";  -- 4じ璸计竟
    signal up_down    : STD_LOGIC := '1';  -- 北璸计よ
begin
    -- だ繵竟–讽 counter_24 璸计疭﹚砞竚 clk_seg 蔼
    process (i_clk, i_reset)
    begin
        if i_reset = '1' then
            counter_24 <= (others => '0');
            clk_seg <= '0';
        elsif rising_edge(i_clk) then
            counter_24 <= counter_24 + 1;
            if counter_24 = "101111101000000000000000" then  -- 砞竚だ繵 (ㄒ璸计琘)
                clk_seg <= not clk_seg;
                counter_24 <= (others => '0');  -- 竚だ繵璸计竟
            end if;
        end if;
    end process;

    -- 璸计竟北沮 clk_seg 秈︽璸计
    process(i_clk, i_reset)
    begin
        if i_reset = '1' then
            counter <= "0000";  -- ﹍0
            up_down <= '1';     -- ﹍璸计
        elsif rising_edge(clk_seg) then  -- ㄏノ clk_seg 璸计牧
            if up_down = '1' then
                if counter = "1001" then
                    up_down <= '0';  -- 笷9秨﹍璸计
                else
                    counter <= counter + 1;
                end if;
            else
                if counter = "0000" then
                    up_down <= '1';  -- 笷0秨﹍璸计
                else
                    counter <= counter - 1;
                end if;
            end if;
        end if;
    end process;

    -- 块璸计竟
    o_count <= counter;

end Behavioral;









