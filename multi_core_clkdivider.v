module multi_div(clk,rst,instruction,wr_en,rd_en,data_out0,data_out1,data_out2,data_out3,
data_empty,data_full,fifo_counter0,fifo_counter1,fifo_counter2,fifo_counter3,counter,
wr_en0,wr_en1,wr_en2,wr_en3,result0,result1,result2,result3,select,clock);
input rst, clk, wr_en, rd_en;
input [11:0] instruction;
output [3:0]clock;
inout wire [11:0] data_out0;
inout wire [11:0] data_out1;
inout wire [11:0] data_out2;
inout wire [11:0] data_out3;
//improved signals
input [7:0]select;
output [3:0]data_empty;
output [3:0] data_full;
//output [3:0] gclock;
output wr_en0,wr_en1,wr_en2,wr_en3;
//output [11:0] fifo_counter;
output [2:0] fifo_counter0;
output [2:0] fifo_counter3;
output [2:0] fifo_counter2;
output [2:0] fifo_counter1;
output reg[4:0]counter;
//input [11:0] instruction;
//output reg [7:0] result;
output wire [7:0] result0;
output wire [7:0] result1;
output wire [7:0] result2;
output wire [7:0] result3;
wire clk_enable0;
wire clk_enable1;
wire clk_enable2;
wire clk_enable3;
assign clk_enable0=(!data_full[0])&(clock[0]);
assign clk_enable1=(!data_full[1])&(clock[1]);
assign clk_enable2=(!data_full[2])&(clock[2]);
assign clk_enable3=(!data_full[3])&(clock[3]);

wire wr_en0;
wire wr_en1;
wire wr_en2;
wire wr_en3;
assign wr_en0=clk_enable0&wr_en;
assign wr_en1=clk_enable1&!clk_enable0&wr_en;
assign wr_en2=!clk_enable1&!clk_enable0&clk_enable2&wr_en;
assign wr_en3=!clk_enable1&!clk_enable0&!clk_enable2&clk_enable3&wr_en;

combined p1(clk,rst,instruction,wr_en0,rd_en,data_out0,data_empty[0],data_full[0],fifo_counter0,result0,select[1:0],clock[0]);
combined p2(clk,rst,instruction,wr_en1,rd_en,data_out1,data_empty[1],data_full[1],fifo_counter1,result1,select[3:2],clock[1]);
combined p3(clk,rst,instruction,wr_en2,rd_en,data_out2,data_empty[2],data_full[2],fifo_counter2,result2,select[5:4],clock[2]);
combined p4(clk,rst,instruction,wr_en3,rd_en,data_out3,data_empty[3],data_full[3],fifo_counter3,result3,select[7:6],clock[3]);
always@(posedge clk)begin
counter <=fifo_counter0+fifo_counter1+fifo_counter2+fifo_counter3;
//result<=result0+result1+result2+result3;
end
endmodule
//////////////

module combined(clk,rst,instruction,wr_en,rd_en,data_out,data_empty,data_full,fifo_counter,result,select,clock);
output clock;
input [1:0]select;
input rst, clk, wr_en, rd_en;
input [11:0] instruction;
inout wire [11:0] data_out;
//input clock_disable;
output data_empty, data_full;
output [ 2:0] fifo_counter;
//input [11:0] instruction;
output wire [7:0] result;
wire clock_2,clock_3,clock_4;
wire clock;
//assign clock1=;
//trail_divider top3(clk,clock_1);
trail_divider#(28'd2) top4(clk,clock_2);
trail_divider#(28'd3) top5(clk,clock_3);
trail_divider#(28'd4) top6(clk,clock_4);
mux41 top3(clk,clock_2,clock_3,clock_4,select,clock);
FIFO top1(clock, rst, instruction, data_out, wr_en, 
rd_en, data_empty, data_full,fifo_counter);
processor3 top2(clock,result,data_out
,data_empty);
endmodule
///////////
module FIFO(clk, rst, buf_in, buf_out, wr_en, rd_en, buf_empty, buf_full,fifo_counter);
input rst, clk, wr_en, rd_en;
input [11:0] buf_in;
output [11:0] buf_out;
output buf_empty, buf_full;
output [ 2:0] fifo_counter;
reg[11:0] buf_out;
reg buf_empty, buf_full;
reg[2:0] fifo_counter;
reg[6:0] rd_ptr, wr_ptr; 
reg[11:0] buf_mem[63 : 0];
always @(posedge clk) begin 
	buf_empty =(fifo_counter==0);
	buf_full =(fifo_counter== 64);
end
//counter update
always @(posedge clk or posedge rst) begin 
	if(rst)
		fifo_counter <= 0; 
	else if((!buf_full && wr_en) && (!buf_empty && rd_en))
		fifo_counter <= fifo_counter; 
	else if( !buf_full && wr_en)
		fifo_counter <= fifo_counter+ 1;
	else if( !buf_empty && rd_en) 
		fifo_counter <= fifo_counter - 1;
	else 
		fifo_counter <= fifo_counter;
end
//giving output(sending to eecution)
always @(posedge clk or posedge rst) begin

	if( rst)
	buf_out <= 0; 
	else begin
		if(rd_en && !buf_empty)
			buf_out <=buf_mem[rd_ptr]; 
		else
			buf_out <=buf_out;
	end
end
//taking input into memory
always @(posedge clk) begin
	if(wr_en&&!buf_full)
		buf_mem[wr_ptr]<=buf_in;
	else
		buf_mem[wr_ptr]<=buf_mem[wr_ptr];

	end
//here updating write pointer and read pointer when they are on which has a loop here 
//that is when we give an instruction in testbench and if we not make wr_en=0 it takes the instruction continuously
//until it is off
always@(posedge clk or posedge rst) begin
	if(rst)	
	 begin
		wr_ptr<=0;
		rd_ptr<=0;
	end
	else 
	begin
		if(!buf_full&& wr_en)
		    wr_ptr<=wr_ptr +1;
		else
		    wr_ptr<=wr_ptr;
		if(!buf_empty&&rd_en)
		    rd_ptr<=rd_ptr+1;
		else
		    rd_ptr<=rd_ptr;
	end
	end	
endmodule

////////////////////////////
////////////////////////
module processor3(clk,status,instruction,buf_empty);
  input clk;
  input [11:0] instruction;
  input buf_empty;
  output reg[7:0] status;
  reg [11:0]  ID_EX_A, ID_EX_B;
  reg [11:0] EX_MEM_ALUOUT;  
  parameter ADD = 4'b0000, SUB = 4'b0001, MUL = 4'b0010, DIV = 4'b0011 , AND = 4'b0100, OR = 4'b0101,XOR = 4'b0110,NOT = 4'b0111,LS = 4'b1000,RS = 4'b1001; 
  always @(posedge clk)  
    begin
	case(instruction[11:8])
        ADD : EX_MEM_ALUOUT = instruction[7:4] + instruction[3:0];
        SUB : EX_MEM_ALUOUT = instruction[7:4] - instruction[3:0];
        MUL : EX_MEM_ALUOUT = instruction[7:4] * instruction[3:0];
        DIV : EX_MEM_ALUOUT = instruction[7:4] / instruction[3:0];
        AND : EX_MEM_ALUOUT = instruction[7:4] & instruction[3:0];
        OR : EX_MEM_ALUOUT = instruction[7:4] | instruction[3:0];
        XOR : EX_MEM_ALUOUT = instruction[7:4] ^ instruction[3:0];
        NOT : EX_MEM_ALUOUT = ~instruction[7:4];
        LS : EX_MEM_ALUOUT = instruction[7:4]<<1;
        RS : EX_MEM_ALUOUT = instruction[7:4]>>1;
      endcase
     status = EX_MEM_ALUOUT;
end 
endmodule

//module gate(input clk,input enable,output gclock);
//assign gclock=clk& enable;
//endmodule

module trail_divider(clock_in,clock_out);
input clock_in; // input clock on FPGA
output  clock_out; // output clock after
parameter DIVISOR=28'd2;//check its synthasizable or not(using decimal)
wire clock_out1;//can I use both reg or wire check as I declared reg as output in module
wire clock_out2;
even_divider#(DIVISOR)start1(clock_in,clock_out1);
odd_divider#(DIVISOR)start2(clock_in,clock_out2);
assign clock_out=(DIVISOR[0])?clock_out2:clock_out1;
endmodule

//combined =odd_divider
module odd_divider(clock_in,clock_out);
input clock_in; // input clock on FPGA
output  clock_out; // output clock after dividing the input clock by divisor
wire clock_out1;//can I use both reg or wire check as I declared reg as output in module
wire clock_out2;
parameter DIVISOR = 28'd2;
even_divider#(DIVISOR)start(clock_in,clock_out1);
FEdge_Dff start1(clock_out1,clock_in,0,clock_out2);
assign clock_out=clock_out1|clock_out2;
endmodule
 
//clock divider general code which works for even divisor(50% duty cycle)
//for odd we combine it with negedge 
module even_divider(clock_in,clock_out);
input clock_in; // input clock on FPGA
output reg clock_out; // output clock after dividing the input clock by divisor
reg[27:0] counter=28'd0;
parameter DIVISOR = 28'd2;
always @(posedge clock_in)
begin
 counter <= counter + 28'd1;
 if(counter>=(DIVISOR-1))
  counter <= 28'd0;
 clock_out <= (counter<DIVISOR/2)?1'b1:1'b0;
end
endmodule

//falling edge reset high asynchronous flip flop
module FEdge_Dff(D,clk,async_reset,Q);
input D; // Data input 
input clk; // clock input 
input async_reset; // asynchronous reset high level 
output reg Q; // output Q 
always @(negedge clk or posedge async_reset) 
begin
 if(async_reset==1'b1)
  Q <= 1'b0; 
 else 
  Q <= D; 
end 
endmodule
//
//4:1 mux
module mux41(clock1,clock2,clock3,clock4,select,clk);
input clock1,clock2,clock3,clock4;
input[1:0] select;
output reg clk;
always@(clock1 or clock2 or clock3 or clock4)
begin
case(select)
2'b00:clk<=clock1;
2'b01:clk<=clock2;
2'b10:clk<=clock3;
2'b11:clk<=clock4;
endcase
end
endmodule
