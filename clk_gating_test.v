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
reg clock_disable; 
//  DUT Output wires  
wire     [7:0] result;  
wire     data_empty;  
wire     data_full,gclock;  
wire    [7:0]fifo_counter;  
wire    [11:0]data_out;
//integer i;  
 //  DUT Instantiation
  
combination_1 tb (clk,rst,instruction,wr_en,rd_en,data_out,data_empty,data_full,fifo_counter,result,clock_disable,gclock);

//  Initial Conditions  
initial  
     begin  
          clock_disable=1'b0;
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
initial 
	begin
		#40 rst=1;
		#40 rst=0;
		#40 wr_en=1;
		instruction = 12'b000010000111;//15
//		#1 wr_en=0;
		#40;
		//wr_en=1;
   		instruction = 12'b000111111100;//3
		#40;
   		instruction = 12'b001001101001;//54
		#40;
   		instruction = 12'b001110100101;//2
		#40;
   		instruction = 12'b010010110111;//3
		#40;
   		instruction = 12'b010101001010;//14
		#40;
   		instruction = 12'b011000101110;//12
		#40
   		instruction = 12'b011101100000;//9
		#40 wr_en=0;
		#40 rd_en=1;
  		
	end

	//clock dioable from algorithm
	initial 
	begin
		#20 clock_disable=1'b0;
		#20 clock_disable=1'b0;
		#20 clock_disable=1'b0;
		#60;clock_disable=1'b0;
		#60;clock_disable=1'b1;
		#40;clock_disable=1'b0;
		#40;clock_disable=1'b1;		
		#40;clock_disable=1'b0;
		#40;clock_disable=1'b1;
		#40; clock_disable=1'b1;
		#80; clock_disable=1'b1;
		#20 ;clock_disable=1'b0;
		#20 ;clock_disable=1'b0;
		#40;clock_disable=1'b0;
		#40;clock_disable=1'b0;
		#40;clock_disable=1'b1;
		#40;clock_disable=1'b0;		
		#40;clock_disable=1'b1;
		#40;clock_disable=1'b0;
		#40clock_disable=1'b1;
		#150clock_disable=1'b0;
		#20clock_disable=1'b1;
	end
////printing the values
//initial
//	begin  
//           $display("----------------------------------------------");  
//           $display("------------------   -----------------------");  
//           $display("----------- SIMULATION RESULT ----------------");  
//           $display("--------------       -------------------");  
//           $display("----------------     ---------------------");  
//           $display("----------------------------------------------");  
//           $monitor("TIME = %d, wr_en = %d, rd_en = %d, data_in = %b,data_out = %d,fifo_counter=%d",$time, wr_en, rd_en, instruction,result,fifo_counter);  
//	#2000 $finish;
//      end  
initial
begin
#2000 $finish;
end		
		
endmodule
