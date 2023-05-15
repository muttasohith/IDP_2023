//here the multicore has only  1 instruction but output is taken from all cores
// the distribution(to which core the input to be given) 
module multicore(clk,rst,instruction,wr_en,rd_en,data_out0,data_out1,data_out2,data_out3,data_empty,
data_full,fifo_counter0,fifo_counter1,fifo_counter2,fifo_counter3,
result0,result1,result2,result3,clock_disable,gclock,wr_en0,wr_en1,wr_en2,wr_en3,counter);
input rst, clk, wr_en, rd_en;
input [11:0] instruction;
inout wire [11:0] data_out0;
inout wire [11:0] data_out1;
inout wire [11:0] data_out2;
inout wire [11:0] data_out3;
//improved signals
input [3:0]clock_disable;
output [3:0]data_empty;
output [3:0] data_full;
output [3:0] gclock;
output wr_en0,wr_en1,wr_en2,wr_en3;
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
assign clk_enable0=(!clock_disable[0]|!data_empty[0])&(!data_full[0])&(clk);
assign clk_enable1=(!clock_disable[1]|!data_empty[1])&(!data_full[1])&(clk);
assign clk_enable2=(!clock_disable[2]|!data_empty[2])&(!data_full[2])&(clk);
assign clk_enable3=(!clock_disable[3]|!data_empty[3])&(!data_full[3])&(clk);
wire wr_en0;
wire wr_en1;
wire wr_en2;
wire wr_en3;
assign wr_en0=clk_enable0&wr_en;
assign wr_en1=clk_enable1&!clk_enable0&wr_en;
assign wr_en2=!clk_enable1&!clk_enable0&clk_enable2&wr_en;
assign wr_en3=!clk_enable1&!clk_enable0&!clk_enable2&clk_enable3&wr_en;

combined p1(clk,rst,instruction,clk_enable0&wr_en,rd_en,data_out0,data_empty[0],
data_full[0],fifo_counter0,result0,clock_disable[0],gclock[0]);

combined p2(clk,rst,instruction,clk_enable1&!clk_enable0&wr_en,rd_en,data_out1,
data_empty[1],data_full[1],fifo_counter1,result1,clock_disable[1],gclock[1]);

combined p3(clk,rst,instruction,!clk_enable1&!clk_enable0&clk_enable2&wr_en,rd_en,
data_out2,data_empty[2],data_full[2],fifo_counter2,result2,clock_disable[2],gclock[2]);

combined p4(clk,rst,instruction,!clk_enable1&!clk_enable0&!clk_enable2&clk_enable3&wr_en,
rd_en,data_out3,data_empty[3],data_full[3],fifo_counter3,result3,clock_disable[3],gclock[3]);

always@(posedge clk)begin
counter <=fifo_counter0+fifo_counter1+fifo_counter2+fifo_counter3;
//result<=result0+result1+result2+result3;
end
endmodule
//////////////
module combined(clk,rst,instruction,wr_en,rd_en,data_out,data_empty,
data_full,fifo_counter,result,clock_disable,gclock);
input rst, clk, wr_en, rd_en;
input [11:0] instruction;
inout wire [11:0] data_out;
input clock_disable;
output data_empty, data_full,gclock;
output [ 2:0] fifo_counter;
output wire [7:0] result;
assign gclock=(clk&!clock_disable)|(clk&!data_empty);
FIFO top1(gclock,rst,instruction,data_out,wr_en,rd_en,data_empty,
data_full,fifo_counter);
processor3 top2(gclock,result,data_out,data_empty);
endmodule
///////////
module FIFO(clk, rst, buf_in, buf_out, wr_en, rd_en, buf_empty,
 buf_full,fifo_counter);
input rst, clk, wr_en, rd_en;
input [11:0] buf_in;
output [11:0] buf_out;
output buf_empty, buf_full;
output [ 2:0] fifo_counter;
reg[11:0] buf_out;
reg buf_empty, buf_full;
wire gclock;
reg[2:0] fifo_counter;
reg[2:0] rd_ptr, wr_ptr; 
reg[11:0] buf_mem[7 : 0];
always @(clk) begin 
	buf_empty =(fifo_counter==0);
	buf_full =(fifo_counter== 7);
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
