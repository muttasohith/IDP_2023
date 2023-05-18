`timescale     10 ps/ 10 ps  
`define          DELAY 10 
module     tb_combined;  
parameter     ENDTIME      = 40000;  

//  DUT Input regs  
reg     clk;  
reg     rst;  
reg     wr_en;  
reg     rd_en;  
reg     [11:0] instruction; 
reg [3:0]clock_disable; 
//  DUT Output wires  
//wire    signal;
wire     [7:0] result0;
wire     [7:0] result1;
wire     [7:0] result2;
wire     [7:0] result3;  
wire     [3:0]data_empty;  
wire     [3:0]data_full;
wire     [3:0]gclock;  
wire    [2:0]fifo_counter0; 
wire    [2:0]fifo_counter1; 
wire    [2:0]fifo_counter2; 
wire    [2:0]fifo_counter3;  
wire    [11:0]data_out0;
wire    [11:0]data_out1;
wire    [11:0]data_out2;
wire    [11:0]data_out3;
wire wr_en0;
wire wr_en1;
wire wr_en2;
wire wr_en3;
wire [4:0]counter;
//integer i;  
 //  DUT Instantiation
  
//combined tb (clk,rst,instruction,wr_en,rd_en,data_out,data_empty,data_full,fifo_counter,result,signal,clock_disable,gclock);
multicore tb (clk,rst,instruction,wr_en,rd_en,data_out0,data_out1,data_out2,data_out3,data_empty,data_full,fifo_counter0,fifo_counter1,fifo_counter2,fifo_counter3,result0,result1,result2,result3,clock_disable,gclock,wr_en0,wr_en1,wr_en2,wr_en3,counter);
//  Initial Conditions  
initial  
     begin  
          //clock_enable=1'b1;
          clock_disable=4'b0000;
          clk     = 1'b1;  
          rst     = 1'b0;  
          wr_en     = 1'b0;  
          rd_en     = 1'b0;  
          instruction     = 12'b0;
     end

//clock generation
initial
	begin  
           forever #`DELAY clk = !clk;  
      end  
//variation
initial 
	begin
		#20 rst=1;
		#20 rst=0;
		#20 wr_en=1;
		instruction = 12'b000010000111;//135
		#40;
   		instruction = 12'b000111111100;//508
		#40;
   		instruction = 12'b001001101001;//617
		#40;
   		instruction = 12'b001110100101;//933
		#40;
   		instruction = 12'b010010110111;//1207
		#40;
   		instruction = 12'b010101001010;//1354
		#40;
   		instruction = 12'b011000101110;//1582
		#40
   		instruction = 12'b011101100000;//1888
		
		#10 rd_en=1;

   		instruction = 12'b100011010000;#20;//2256
  		instruction = 12'b100100100000;#20;//2336
  	 	instruction = 12'b001011111110;#20;//766
   		instruction = 12'b000111101110;#20;//494
  		instruction = 12'b010100010110;#20;//1302
  		instruction = 12'b000011111111;#20;//255
  		instruction = 12'b001111110011;#20;//1011
  		instruction = 12'b011001111010;#20;//1658
  		wr_en=0;
  		#200
  		//#10 rd_en=0;
         wr_en=1;
   		#10 instruction = 12'b100011010000;//2256
   		#10 wr_en=0;
   		#200;
   		wr_en=1;
  		instruction = 12'b100100100000;#20;//2336
  		#10 rd_en=0;
  	 	#40 instruction = 12'b001011111110;#20;//766
   		instruction = 12'b000111101110;#20;//494
  		instruction = 12'b010100010110;#20;//1302
  		instruction = 12'b000011111111;#20;//255
  		instruction = 12'b001111110011;#20;//1011
  		instruction = 12'b011001111010;#20;//1658
  		#30 wr_en=0;
  		#10 rd_en=1;
  		
	end
	//clock dioable from algorithm
	initial 
	begin
		#60 clock_disable=4'b0000;
		#20 clock_disable=4'b0111;
		#20 clock_disable=4'b1110;
		#60;clock_disable=4'b0010;
		#60;clock_disable=4'b0001;
		#40;clock_disable=4'b0100;
		#40;clock_disable=4'b1001;		
		#40;clock_disable=4'b0000;
		#40;clock_disable=4'b1000;
		#40; clock_disable=4'b0101;
		#80; clock_disable=4'b1011;
		#20 ;clock_disable=4'b0011;
		#20 ;clock_disable=4'b1100;
		#40;clock_disable=4'b0110;
		#40;clock_disable=4'b0010;
		#40;clock_disable=4'b1111;
		#40;clock_disable=4'b0011;		
		#40;clock_disable=4'b1100;
		#40;clock_disable=4'b0001;
		#40 clock_disable=4'b1001;
		#150 clock_disable=4'b1100;
		#20 clock_disable=4'b1111;
	end
//printing the values
//initial
//	begin  
//           $display("----------------------------------------------");  
//           $display("------------------   -----------------------");  
//           $display("----------- SIMULATION RESULT ----------------");  
//           $display("--------------       -------------------");  
//           $display("----------------     ---------------------");  
//           $display("----------------------------------------------");  
//           $monitor("TIME = %d, wr_en = %d, rd_en = %d, data_in = %b",$time, wr_en, rd_en, instruction);  
//		#2000 $finish;
//      end  
		
initial
begin
#2000 $finish;
end		
endmodule
