LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY vga_shapes_tb IS
END vga_shapes_tb;

ARCHITECTURE behavior OF vga_shapes_tb IS

    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT vga_shapes
        GENERIC (
            h_pixels  : INTEGER := 800;
            h_fp      : INTEGER := 56;
            h_pulse   : INTEGER := 120;
            h_bp      : INTEGER := 64;
            h_pol     : STD_LOGIC := '1';
            v_pixels  : INTEGER := 600;
            v_fp      : INTEGER := 37;
            v_pulse   : INTEGER := 6;
            v_bp      : INTEGER := 23;
            v_pol     : STD_LOGIC := '1'
        );
        PORT (
            clk        : IN STD_LOGIC;
            rst        : IN STD_LOGIC;
            red_out    : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
            green_out  : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
            blue_out   : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
            h_sync     : OUT STD_LOGIC;
            v_sync     : OUT STD_LOGIC
        );
    END COMPONENT;

    -- Signals for simulation
    SIGNAL clk_tb       : STD_LOGIC := '0';
    SIGNAL rst_tb       : STD_LOGIC := '1';
    SIGNAL red_tb       : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL green_tb     : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL blue_tb      : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL h_sync_tb    : STD_LOGIC;
    SIGNAL v_sync_tb    : STD_LOGIC;

    -- Clock period definition
    CONSTANT clk_period : TIME := 10 ns; -- 100 MHz

BEGIN
    -- Instantiate the Unit Under Test (UUT)
    uut: vga_shapes
        PORT MAP (
            clk       => clk_tb,
            rst       => rst_tb,
            red_out   => red_tb,
            green_out => green_tb,
            blue_out  => blue_tb,
            h_sync    => h_sync_tb,
            v_sync    => v_sync_tb
        );

    -- Clock process
    clk_process : PROCESS
    BEGIN
        WHILE NOW < 10 ms LOOP
            clk_tb <= '0';
            WAIT FOR clk_period / 2;
            clk_tb <= '1';
            WAIT FOR clk_period / 2;
        END LOOP;
        WAIT;
    END PROCESS;

    -- Stimulus process
    stim_proc: PROCESS
    BEGIN
        -- Reset for a few cycles
        rst_tb <= '1';
        WAIT FOR 50 ns;
        rst_tb <= '0';

        -- Allow simulation to run
        WAIT FOR 10 ms;
        
        -- End simulation
        WAIT;
    END PROCESS;

END behavior;