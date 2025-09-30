# VHDL Counter Debug Analysis and Fixes

## Issues Identified

### 1. Race Condition in Counter Processes
**Problem**: The original counter processes included `state` in their sensitivity lists:
```vhdl
counter1:process(i_clk, i_rst, state)  -- BAD: state in sensitivity list
```

**Impact**: This creates a combinational loop where:
- FSM updates state based on counter values
- Counter processes immediately react to state changes (due to sensitivity)
- This can cause multiple updates within the same clock cycle
- Results in unpredictable counter increments/decrements

**Fix**: Removed `state` from sensitivity lists:
```vhdl
counter1:process(i_clk, i_rst)  -- GOOD: only clock and reset
```

### 2. Counter2 Unintended Increment (253→254)
**Problem**: In state s3, counter2 was set to 254:
```vhdl
when s3 =>
    count2 <= "11111110"; -- 設定為254 (BAD)
```

**Impact**: 
- Counter2 starts at 253 (initialization)
- When transitioning to state s3, it jumps to 254
- This causes the "unexpected increment" mentioned in the problem

**Fix**: Changed to reset counter2 to 253 instead of 254:
```vhdl
when s3 =>
    count2 <= "11111101"; -- 重置為253而不是254 (GOOD)
```

### 3. Timing and Synchronization
**Problem**: With state in sensitivity lists, counter updates could happen:
- Before state transitions (causing missed transitions)
- After state transitions (causing extra counts)
- Multiple times per clock cycle

**Fix**: By making all processes purely synchronous (only sensitive to clock and reset), all updates happen at the same clock edge in a predictable order.

## Expected Behavior After Fixes

### State Machine Flow:
1. **s0**: counter1 increments from 0 to 8, then transitions to s2
2. **s2**: counter1 resets to 0, counter3 increments from 0 to 10, then transitions to s1
3. **s1**: counter3 resets to 0, counter2 decrements from 253 to 80, then transitions to s3
4. **s3**: counter2 resets to 253, immediately transitions to s0

### Counter Values Throughout Cycle:
- **counter1**: 0→8 (in s0), then stays 0 in other states
- **counter2**: starts at 253, decrements 253→80 (in s1), resets to 253 (in s3)
- **counter3**: 0→10 (in s2), then stays 0 in other states

### Key Improvements:
1. **No Race Conditions**: All processes are purely synchronous
2. **Predictable Timing**: All updates happen on clock edges
3. **No Unintended Increments**: Counter2 stays within expected range (253↔80)
4. **Clean State Transitions**: FSM and counters update in proper sequence

## Validation Points

The testbench validates:
1. Proper initialization values
2. Counter increments/decrements only in correct states
3. State transitions occur at correct counter values
4. No unexpected value jumps or increments
5. Proper reset behavior

## Technical Notes

- Used `std_logic_unsigned` for arithmetic operations (as in original)
- Maintained original functionality while fixing timing issues
- All changes are minimal and surgical
- Preserved original comments and structure