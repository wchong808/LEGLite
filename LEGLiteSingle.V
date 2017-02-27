module LEGLiteSingle(
	iaddr,		// Program memory address.  This is the program counter
	daddr,		// Data memory address
	dwrite,		// Data memory write enable
	dread,		// Data memory read enable
	dwdata,		// Data memory write data
	alu_out,	// Output of alu for debugging purposes
	clock,
	idata,		// Program memory output, which is the current instruction
	ddata,		// Data memory output, read data
	reset,
	probe
	);

output [15:0] iaddr;//pc
output [15:0] daddr;//alu out
output dwrite;//mem write
output dread;//mem read
output [15:0] dwdata;//write data, or read data 2 from reg file
output [15:0] alu_out;//alu out
input clock;
input [15:0] idata; // Instructions 
input [15:0] ddata;	//read data from data memory
input reset;
output [15:0] probe;

//wires for control unit
wire reg2loc;
wire branch;
wire memread;
wire memtoreg;
wire[2:0] alu_select;
wire memwrite;
wire alusrc;
wire regwrite;
wire[2:0] readregister2;
wire[15:0] outputfrompc;

wire[15:0] daddr, alu_out, iaddr, dwdata;
wire dwrite,dread;

assign daddr = result; //address to data memory = alu result
assign alu_out = result; // alu out = alu result
assign iaddr = outputfrompc; // current pc = output from pc module
assign dwrite = memwrite; //memwrite
assign dread = memread; //memread
assign dwdata = rdata2; //data memory write data = read data 2 from reg file
assign probe = alumuxresult;

wire[15:0] rdata1, rdata2, extended, rdata, wdata;
wire [15:0] alumuxresult;
wire[15:0] result;

//IM im1(idata,outputfrompc);

Control control1(
reg2loc,
branch,
memread,
memtoreg,
alu_select,
memwrite,
alusrc,
regwrite,
idata[15:13] //opcode
);

//instantiate 2 input mux to choose the second read register at reg file

MUX2 regfilemux(
readregister2,   // Output of multiplexer which is the first multiplexer at the reg file
idata[12:10],  // Input 0
idata[2:0],  // Input 1
reg2loc    // 1-bit select
);

//Send in the register 1 and write register as bits of idata. send in readregister2 from regfile mux module.
//wdata still needs to be defined

RegFile regfile1(
rdata1,  // read data output 1
rdata2,  // read data output 2
clock,
wdata,   // write data input
idata[2:0], //waddr write address
idata[5:3], //raddr1 read address 1
readregister2, //raddr2 read address 2
regwrite // write enable
);

MUX2 alumux(
alumuxresult,   // Output of multiplexer
rdata2,  // Input 0
extended,  // Input 1
alusrc    // 1-bit select
);

assign extended = {{9{idata[12]}},idata[12:6]};
	
ALU alu1(
	result,      // 16-bit output from the ALU
	zero_result, // equals 1 if the result is 0, and 0 otherwise
	rdata1,     // data input
	alumuxresult,     // data input
	alu_select       // 3-bit select
	);


//DMemory_IO dmemory_io1(
//rdata,  // read data
//io_display,	// IO port connected to 7 segment display
//clock,  // clock
//result,   // address
//rdata2,  // write data *************************
//memwrite,  // write enable
//memread,   // read enable
//io_sw0, // IO port connected to sliding switch 0
//io_sw1  // IO port connected to sliding switch 1
//);

MUX2 datamemorymux(
wdata,   // Output of multiplexer
result,  // Input 0
ddata,  // Input 1
memtoreg    // 1-bit select
);


PCLogic pclogic1(
outputfrompc, //current pc value input
clock,	// clock input
extended, //signext input
branch,	// CBZ branch control signal input from control unit
zero_result, //alu_zero, zero input from ALU, used in cond branch
reset		// reset input
);




	
endmodule