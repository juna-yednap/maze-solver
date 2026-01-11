# Maze Solver Bot (Verilog)

This project implements an autonomous maze-solving bot using Verilog and a finite state machine (FSM) architecture. The design employs a **dead-end filling–based maze-solving strategy**, enabling efficient navigation while minimizing hardware complexity and execution time.

## Key Features
- FSM-based control with IDLE, START, DECIDE, and MOVE states
- Dead-end filling approach for optimized hardware and time performance
- Movement decisions using left, forward, and right wall sensors
- Direction and position tracking within a 2D grid
- Dead-end and visited-cell marking for efficient path exploration

## Verification
- Comprehensive testbench validates state transitions, movement logic, and dead-end handling
- Simulation confirms correct traversal across multiple maze configurations

## Tools Used
- Verilog HDL
- ModelSim

## Design Philosophy
The dead-end filling strategy allows the maze to be solved without recursion or stack-based memory, making it well-suited for hardware implementation with predictable timing behavior.
