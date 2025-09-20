# No-Internet Dino Game on FPGA (DE1-SoC)

## Overview
This project implements a hardware version of the Chrome offline “Dino Game” on the **DE1-SoC FPGA board**. The game logic, VGA display, PS/2 input, and sprite animation are fully written in **Verilog**. The dino character jumps vertically to avoid obstacles, and game progress is visualized on the VGA display.

Demo Video: https://drive.google.com/file/d/1n12yXG7QHoS2hHFYll4iL88rVbMl4ORd/view 

<img width="1081" height="549" alt="image" src="https://github.com/user-attachments/assets/328dd2ee-b066-4715-b41b-5096eb51154d" />

<img width="1166" height="609" alt="image" src="https://github.com/user-attachments/assets/796cd4fb-743a-4236-9fc9-4564a69f7b17" />

<img width="1172" height="651" alt="image" src="https://github.com/user-attachments/assets/f230c788-af7a-4950-977b-c2fbfbb00583" />

<img width="1020" height="566" alt="image" src="https://github.com/user-attachments/assets/4c56ff3e-8480-4eec-a78e-59ac7db0685a" />

## Features
- **Dino Jump Logic**:  
  - Dino moves only in the y-direction.  
  - Jump triggered by push button (`KEY1`).  
  - Gravity implemented by decrementing y-position over time.  

- **VGA Display**:  
  - 640×480 resolution.  
  - Sprite rendering handled using on-board RAM with frame overwrite.  
  - Object plotting at (x, y) coordinates.  

- **Animation Control**:  
  - Sprites stored in memory.  
  - Overwritten dynamically as the dino moves.  

- **User Input**:  
  - Push button for jump.  
  - PS/2 keyboard support for starting and controlling gameplay.  

---

## Implementation Details
- **VGA Module**: Generates synchronization signals and plots pixels for the dino object and obstacles.  
- **RAM Integration**: Stores sprite data for the dino. Data is overwritten when the object moves.  
- **Game Logic FSM**: Handles jump state, falling state, and collision detection.  
- **Object Coordinates**: Dino initialized at fixed x-position with variable y-position updated on jump/decay.  
- **Input Handling**:  
  - KEY1 press sets dino y-position to jump height.  
  - Continuous clock cycles reduce y-position to simulate falling.  

---

## Repository Structure
