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
reg [7:0]select; 
//  DUT Output wires  
//wire    signal;
wire     [7:0] result0;
wire     [7:0] result1;
wire     [7:0] result2;
wire     [7:0] result3;  
wire     [3:0]data_empty;  
wire     [3:0]data_full;
//wire     [3:0]gclock;  
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
wire [3:0]clock;
//integer i;  
 //  DUT Instantiation
  
multi_div tb (clk,rst,instruction,wr_en,rd_en,data_out0,data_out1,data_out2,data_out3,
data_empty,data_full,fifo_counter0,fifo_counter1,fifo_counter2,fifo_counter3,counter,
wr_en0,wr_en1,wr_en2,wr_en3,result0,result1,result2,result3,select,clock);
//  Initial Conditions  
initial  
     begin  
          select=8'b00000000;
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
 
  
////variation
//initial 
//	begin
//		#20 rst=1;
//		#20 rst=0;
//		#20 wr_en=1;
//		instruction = 12'b000010000111;//135
//		#40;
//   		instruction = 12'b000111111100;//508
//		#40;
//   		instruction = 12'b001001101001;//617
//		#40;
//   		instruction = 12'b001110100101;//933
//		#40;
//   		instruction = 12'b010010110111;//1207
//		#40;
//   		instruction = 12'b010101001010;//1354
//		#40;
//   		instruction = 12'b011000101110;//1582
//		#40
//   		instruction = 12'b011101100000;//1888
		
//		#10 rd_en=1;

//   		instruction = 12'b100011010000;#20;//2256
//  		instruction = 12'b100100100000;#20;//2336
//  	 	instruction = 12'b001011111110;#20;//766
//   		instruction = 12'b000111101110;#20;//494
//  		instruction = 12'b010100010110;#20;//1302
//  		instruction = 12'b000011111111;#20;//255
//  		instruction = 12'b001111110011;#20;//1011
//  		instruction = 12'b011001111010;#20;//1658
//  		wr_en=0;
//  		#200
//  		//#10 rd_en=0;
//         wr_en=1;
//   		#10 instruction = 12'b100011010000;//2256
//   		#10 wr_en=0;
//   		#200;
//   		wr_en=1;
//  		instruction = 12'b100100100000;#20;//2336
//  		#10 rd_en=0;
//  	 	#40 instruction = 12'b001011111110;#20;//766
//   		instruction = 12'b000111101110;#20;//494
//  		instruction = 12'b010100010110;#20;//1302
//  		instruction = 12'b000011111111;#20;//255
//  		instruction = 12'b001111110011;#20;//1011
//  		instruction = 12'b011001111010;#20;//1658
//  		#30 wr_en=0;
//  		#10 rd_en=1;
  		
//	end
initial 
	begin
		#200 rst=1;
		#200 rst=0;
		#200 wr_en=1;
		instruction = 12'b000010000111;//15
//		#1 wr_en=0;
		#400;
		wr_en=1;
   		instruction = 12'b000111111100;//3
		#400;
   		instruction = 12'b001001101001;//54
		#400;
   		instruction = 12'b001110100101;//2
		#400;
   		instruction = 12'b010010110111;//3
		#400;
   		instruction = 12'b010101001010;//14
		#400;
   		instruction = 12'b011000101110;//12
		#400
   		instruction = 12'b011101100000;//9
		
		#100 rd_en=1;

   		instruction = 12'b100011010000;#200;//6
  		instruction = 12'b100100100000;#200;//
  	 	instruction = 12'b001011111110;#200;
   		instruction = 12'b000111101110;#200;
  		instruction = 12'b010100010110;#200;
  		instruction = 12'b000011111111;#200;
  		instruction = 12'b001111110011;#200;
  		instruction = 12'b011001111010;#200;
  		wr_en=0;
  		#200
  		//#10 rd_en=0;
         wr_en=1;
   		#100 instruction = 12'b100011010000;
   		#100 wr_en=0;
   		#200;
   		wr_en=1;
  		instruction = 12'b100100100000;#200;
  		#100 rd_en=0;
  	 	#150 instruction = 12'b001011111110;#200;
   		instruction = 12'b000111101110;#200;
  		instruction = 12'b010100010110;#200;
  		instruction = 12'b000011111111;#200;
  		instruction = 12'b001111110011;#200;
  		instruction = 12'b011001111010;#200;
  		#300 wr_en=0;
  		#100 rd_en=1;
  		
	end
//	//clock dioable from algorithm
//	initial 
//	begin
//		#60 select=8'b00000000;
//		#20 select=8'b01110001;
//		#20 select=8'b11100010;
//		#60;select=8'b00100011;
//		#60;select=8'b00010100;
//		#40;select=8'b01000101;
//		#40;select=8'b10010110;//7		
//		#40;select=8'b00000111;//8
//		#40;select=8'b10001000;//9
//		#40; select=8'b01011001;//10
//		#80; select=8'b10111010;//11
//		#20 ;select=8'b00111011;//12
//		#20 ;select=8'b11001100;
//		#40;select=8'b01101101;
//		#40;select=8'b00101110;
//		#40;select=8'b11111111;
//		#40;select=8'b01110000;		
//		#40;select=8'b11001000;
//		#40;select=8'b00010101;
//		#40 select=8'b10010011;
//		#150 select=8'b11000111;
//		#20 select=8'b11110000;
//	end
initial 
	begin
		#200 select=8'b00000000;
		#200 select=8'b01110001;
		#200 select=8'b11100010;
		#600;select=8'b00100011;
		#600;select=8'b00010100;
		#400;select=8'b01000101;
		#400;select=8'b10010110;		
		#400;select=8'b00000111;
		#400;select=8'b10001000;
		#400; select=8'b01011001;
		#800; select=8'b10111010;
		#200 ;select=8'b00111011;
		#200 ;select=8'b11001100;
		#400;select=8'b01101101;
		#400;select=8'b00101110;
		#400;select=8'b11111111;
		#400;select=8'b01110000;		
		#400;select=8'b11001000;
		#400;select=8'b00010101;
		#400 select=8'b10010011;
		#150 select=8'b11000111;
		#200 select=8'b11110000;
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
//		#10000 $finish;
//      end  
initial
begin
#10000 $finish;
end		
		
endmodule
