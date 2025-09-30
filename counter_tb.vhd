library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity counter_tb is
end counter_tb;

architecture testbench of counter_tb is
    -- Component declaration
    component counter
        Port ( i_clk    : in  STD_LOGIC;
               i_rst    : in  STD_LOGIC;
               o_count1 : out STD_LOGIC_VECTOR (7 downto 0);
               o_count2 : out STD_LOGIC_VECTOR (7 downto 0);
               o_count3 : out STD_LOGIC_VECTOR (7 downto 0)
               );
    end component;
    
    -- Testbench signals
    signal clk : STD_LOGIC := '0';
    signal rst : STD_LOGIC := '0';
    signal count1_out : STD_LOGIC_VECTOR(7 downto 0);
    signal count2_out : STD_LOGIC_VECTOR(7 downto 0);
    signal count3_out : STD_LOGIC_VECTOR(7 downto 0);
    
    -- Clock period
    constant clk_period : time := 10 ns;
    
begin
    -- Instantiate the Unit Under Test (UUT)
    uut: counter Port map (
        i_clk => clk,
        i_rst => rst,
        o_count1 => count1_out,
        o_count2 => count2_out,
        o_count3 => count3_out
    );
    
    -- Clock process
    clk_process: process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;
    
    -- Stimulus process
    stim_proc: process
    begin
        -- Reset
        rst <= '0';
        wait for 20 ns;
        rst <= '1';
        wait for 20 ns;
        
        -- Let it run and observe behavior
        wait for 2000 ns;
        
        -- End simulation
        wait;
    end process;
    
end testbench;