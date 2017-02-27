This is a simplified version of the single-cycle LEGv8.

The computer is able to run the following instructions: ADD, ADDI, CBZ, LD, ST, and ANDI. The program that runs the computer accesses the IO ports.

LEGLiteSingle.v has the LEGLite processor module that holds the implemented insturctions.

testbench-LEGLiteSingle-Stage2.v is the test bench for the LEGLiteSingle.v. 

LEGLite-Control.v  has the controller module of the LEGLite.

testbenchControl.v is the test bench for the controller.

LEGLite-PC.v has the PC control logic. 

testbenchPC.v is the test bench for PCLogic module which is the module that does PC control.

IMV2.v is the program that interacts with the I/O ports: input  switch 0 at adress 0xfff0, and output port connected to the seven segment display at address 0xfffa. It will continually check switch 0. If the switch = 0 then it outputs "0" to the seven degment display. If the switch = 1 then it putputs "1" to the seven segment display.




#LEGLite
