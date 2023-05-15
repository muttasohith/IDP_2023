`timescale     10 ps/ 10 ps  
`define          DELAY 10  
module     tb_combined;  
parameter     ENDTIME      = 40000;  

//  DUT Input regs  
reg     clk;  
reg     rst;
reg[1:0]select;  
reg     wr_en;  
reg     rd_en;  
reg     [11:0] instruction; 
//reg clock_disable; 
//  DUT Output wires  
wire     [7:0] result;  
wire     data_empty;  
wire     data_full;  
wire    [7:0]fifo_counter;  
wire    [11:0]data_out;
wire clock;
//integer i;  
 //  DUT Instantiation
  
freq_divider tb (clk,rst,instruction,wr_en,rd_en,data_out,data_empty,data_full,fifo_counter,result,select,clock);

//  Initial Conditions  
initial  
     begin  
          //clock_enable=1'b1;
//          clock_disable=1'b0;
          clk     = 1'b1;  
          rst     = 1'b0;  
          wr_en     = 1'b0;  
          rd_en     = 1'b0;  
          instruction     = 12'b0;
          select    =2'b00;
	//data_out     = 0;  
	  //fifo_counter=0;
     end

//clock generation
initial
	begin  
           forever #`DELAY clk = !clk;  
      end 
 
  
//variation
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
//initial 
//	begin
//		#160 rst=1;
//		#160 rst=0;
//		#160 wr_en=1;
//		instruction = 12'b000010000111;//15
////		#1 wr_en=0;
//		#160;
//		//wr_en=1;
//   		instruction = 12'b000111111100;//3
//		#160;
//   		instruction = 12'b001001101001;//54
//		#160;
//   		instruction = 12'b001110100101;//2
//		#160;
//   		instruction = 12'b010010110111;//3
//		#160;
//   		instruction = 12'b010101001010;//14
//		#160;
//   		instruction = 12'b011000101110;//12
//		#160
//   		instruction = 12'b011101100000;//9
//		#160 wr_en=0;
//		#160 rd_en=1;

////   		instruction = 12'b100011010000;#160;//6
////  		instruction = 12'b100100100000;#160;//
////  	 	instruction = 12'b001011111110;#160;
////   		instruction = 12'b000111101110;#160;
////  		instruction = 12'b010100010110;#160;
////  		instruction = 12'b000011111111;#160;
////  		instruction = 12'b001111110011;#160;
////  		instruction = 12'b011001111010;#160;
////  		wr_en=0;
////  		#320
////  		//#10 rd_en=0;
////         wr_en=1;
////   		#80 instruction = 12'b100011010000;
////   		#80 wr_en=0;
////   		#160;
////   		wr_en=1;
////  		instruction = 12'b100100100000;#160;
////  		#80 rd_en=0;
////  	 	#80 instruction = 12'b001011111110;#160;
////   		instruction = 12'b000111101110;#160;
////  		instruction = 12'b010100010110;#160;
////  		instruction = 12'b000011111111;#160;
////  		instruction = 12'b001111110011;#160;
////  		instruction = 12'b011001111010;#160;
////  		#300 wr_en=0;
////  		#100 rd_en=0;
  		
//	end

//	//clock dioable from algorithm
	initial 
	begin
		#200 select=2'b00;
		#200 select=2'b01;
		#200 select=2'b01;
		#600;select=2'b10;
		#600;select=2'b10;
		#400;select=2'b01;
		#400;select=2'b11;		
		#400;select=2'b01;
		#400;select=2'b11;
		#400; select=2'b10;
		#800; select=2'b01;
		#200 ;select=2'b00;
		#200 ;select=2'b01;
		#400;select=2'b10;
		#400;select=2'b00;
		#400;select=2'b11;
		#400;select=2'b01;		
		#400;select=2'b11;
		#400;select=2'b11;
		#400select=2'b11;
		#150select=2'b10;
		#200select=2'b11;
	end

	//clock dioable from algorithm
//	initial 
//	begin
//		#160 select=2'b00;
//		#160 select=2'b01;
//		#160 select=2'b01;
//		#480;select=2'b10;
//		#480;select=2'b10;
//		#320;select=2'b01;
//		#320;select=2'b11;		
//		#320;select=2'b01;
//		#320;select=2'b11;
//		#320; select=2'b10;
//		#640; select=2'b01;
//		#160 ;select=2'b00;
//		#160 ;select=2'b01;
//		#160;select=2'b10;
//		#320;select=2'b00;
//		#320;select=2'b11;
//		#320;select=2'b01;		
//		#320;select=2'b11;
//		#320;select=2'b11;
//		#320select=2'b11;
//		#320select=2'b10;
//		#160select=2'b11;
//	end

//printing the values
initial
	begin  
           $display("----------------------------------------------");  
           $display("------------------   -----------------------");  
           $display("----------- SIMULATION RESULT ----------------");  
           $display("--------------       -------------------");  
           $display("----------------     ---------------------");  
           $display("----------------------------------------------");  
           $monitor("TIME = %d, wr_en = %d, rd_en = %d, data_in = %b,data_out = %d,fifo_counter=%d",$time, wr_en, rd_en, instruction,result,fifo_counter);  
		#10000 $finish;
      end  
		
		
endmodule