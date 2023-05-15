//It is a single core processor(to be implemented in PL) where clock gating is implemented
module combination_1(clk,rst,instruction,wr_en,rd_en,data_out,
data_empty,data_full,fifo_counter,result,clock_disable,gclock);
input rst, clk, wr_en, rd_en;
input [11:0] instruction;
inout wire [11:0] data_out;
input clock_disable;
output data_empty, data_full,gclock;
output [ 7:0] fifo_counter;
output wire [7:0] result;
//clock gating
assign gclock=(clk&!clock_disable)|(clk&!data_empty);
FIFO top1(gclock, rst, instruction, data_out, wr_en, rd_en, 
data_empty, data_full,fifo_counter);
processor3 top2(gclock,result,data_out);
endmodule
///////////
module FIFO(clk, rst, buf_in, buf_out, wr_en, rd_en,
 buf_empty, buf_full,fifo_counter);
input rst, clk, wr_en, rd_en;
input [11:0] buf_in;
output [11:0] buf_out;
output buf_empty, buf_full;
output [ 7:0] fifo_counter;
reg[11:0] buf_out;
reg buf_empty, buf_full;
wire gclock;
reg[7:0] fifo_counter;
reg[6:0] rd_ptr, wr_ptr; 
reg[11:0] buf_mem[63 : 0];
//updating the status (empty and full)
always @(clk) begin 
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
//giving output(sending to excecution)
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

module processor3(clk,status,instruction);
  input clk;
  input [11:0] instruction;
  output reg[7:0] status;
  reg [7:0] EX_MEM_ALUOUT;  
  parameter ADD = 4'b0000, SUB = 4'b0001, 
  MUL = 4'b0010, DIV = 4'b0011 ,
   AND = 4'b0100, OR = 4'b0101,
   XOR = 4'b0110,NOT = 4'b0111,LS = 4'b1000,RS = 4'b1001; 
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
