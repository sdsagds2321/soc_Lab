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
    
    -- Helper function to convert std_logic_vector to integer
    function to_integer(slv : std_logic_vector) return integer is
    begin
        return to_integer(unsigned(slv));
    end function;
    
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
        -- Test reset behavior
        rst <= '0';
        wait for 20 ns;
        
        -- Expected initial values after reset:
        -- count1 = 0, count2 = 253, count3 = 0
        -- state = s0
        
        rst <= '1';
        wait for clk_period;
        
        -- State s0: count1 should increment from 0 to 8
        -- Expected: count1 increases, count2 stays 253, count3 stays 0
        for i in 1 to 10 loop
            wait for clk_period;
            -- Report values for debugging
            report "Cycle " & integer'image(i) & 
                   ": count1=" & integer'image(to_integer(count1_out)) &
                   ", count2=" & integer'image(to_integer(count2_out)) &
                   ", count3=" & integer'image(to_integer(count3_out));
        end loop;
        
        -- State s2: count3 should increment from 0 to 10, count1 reset to 0
        -- Expected: count1 = 0, count2 = 253, count3 increases
        for i in 1 to 15 loop
            wait for clk_period;
            report "S2 Cycle " & integer'image(i) & 
                   ": count1=" & integer'image(to_integer(count1_out)) &
                   ", count2=" & integer'image(to_integer(count2_out)) &
                   ", count3=" & integer'image(to_integer(count3_out));
        end loop;
        
        -- State s1: count2 should decrement from 253 to 80, count3 reset to 0
        -- Expected: count1 = 0, count2 decreases, count3 = 0
        for i in 1 to 180 loop
            wait for clk_period;
            if i mod 20 = 0 then  -- Report every 20 cycles
                report "S1 Cycle " & integer'image(i) & 
                       ": count1=" & integer'image(to_integer(count1_out)) &
                       ", count2=" & integer'image(to_integer(count2_out)) &
                       ", count3=" & integer'image(to_integer(count3_out));
            end if;
        end loop;
        
        -- State s3: count2 should reset to 253
        -- Expected: count1 = 0, count2 = 253, count3 = 0
        for i in 1 to 5 loop
            wait for clk_period;
            report "S3 Cycle " & integer'image(i) & 
                   ": count1=" & integer'image(to_integer(count1_out)) &
                   ", count2=" & integer'image(to_integer(count2_out)) &
                   ", count3=" & integer'image(to_integer(count3_out));
        end loop;
        
        report "Testbench completed";
        wait;
    end process;
    
end testbench;