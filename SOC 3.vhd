library IEEE; 
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity two_counter is
    port (
        i_clk    : in std_logic;
        i_rst    : in std_logic;
        o_count1 : out std_logic_vector(3 downto 0);
        o_count2 : out std_logic_vector(3 downto 0)
    );
end two_counter;

architecture Behavioral of two_counter is
    signal count1 : std_logic_vector(3 downto 0) := "0001"; -- Start at 1
    signal count2 : std_logic_vector(3 downto 0) := "1001"; -- Start at 9
    signal state  : std_logic := '0'; -- '0' for count1, '1' for count2
begin

    o_count1 <= count1;
    o_count2 <= count2;

    -- FSM to control switching between counters
    FSM: process(i_clk, i_rst)
    begin
        if i_rst = '0' then
            state <= '0'; -- Start with count1
        elsif rising_edge(i_clk) then
            case state is
                when '0' => -- count1 active
                    if count1 = "1001" then -- When count1 reaches 9
                        state <= '1'; -- Switch to count2
                    end if;
                when '1' => -- count2 active
                    if count2 = "0000" then -- When count2 reaches 0
                        state <= '0'; -- Switch back to count1
                    end if;
                when others =>
                    state <= '0';
            end case;
        end if;
    end process;

    -- Counter for count1
    counter1: process(i_clk, i_rst, state)
    begin
        if i_rst = '0' then
            count1 <= "0000"; -- Reset to 1
        elsif rising_edge(i_clk) then
            if state = '0' then
                if count1 = "1001" then
                    count1 <= "0000"; -- Reset count1 when it reaches 9
                else
                    count1 <= count1 + 1;
                end if;
            end if;
        end if;
    end process;

    -- Counter for count2
    counter2: process(i_clk, i_rst, state)
    begin
        if i_rst = '0' then
            count2 <= "1001"; -- Reset to 9
        elsif rising_edge(i_clk) then
            if state = '1' then
                if count2 = "0000" then
                    count2 <= "1001"; -- Reset count2 when it reaches 0
                else
                    count2 <= count2 - 1;
                end if;
            end if;
        end if;
    end process;

end Behavioral;


