library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_counter_control is
-- Testbench ⊿Τ癸硈钡梆
end tb_counter_control;

architecture behavioral of tb_counter_control is
    -- じン
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

    -- 代刚癟腹
    signal clk         : std_logic := '0';
    signal rst         : std_logic := '0';
    signal mode        : std_logic := '1';  -- 箇砞计家Α
    signal upper_limit1 : unsigned(3 downto 0) := "1111"; -- 璸计竟1
    signal lower_limit1 : unsigned(3 downto 0) := "0001"; -- 璸计竟1
    signal upper_limit2 : unsigned(3 downto 0) := "0110"; -- 璸计竟2
    signal lower_limit2 : unsigned(3 downto 0) := "0010"; -- 璸计竟2
    signal counter1    : unsigned(3 downto 0);
    signal counter2    : unsigned(3 downto 0);

    -- ネΘ–10 ns ち传Ω
    constant clk_period : time := 10 ns;

begin
    -- ㄒて璸计竟じン
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

    -- ネΘ祘
    clk_process: process
    begin
        while true loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    -- 代刚瑈祘
    test_process: process
    begin
        -- ﹍砞
        rst <= '1';  -- ぃ砞
        wait for 20 ns;
        rst <= '0';  -- 砞币笆
        wait for 20 ns;
        rst <= '1';  -- 睦砞

        -- ﹍て家Α计家Α
       mode <= '1'; -- 砞﹚计家Α

-- 单100 nsち传搭计家Α
       wait for 120 ns;
       mode <= '0'; -- э搭计家Α

-- 单100 nsち计家Α
      wait for 120 ns;
      mode <= '1';


        -- 挡家览
        wait;
    end process;
end behavioral;

