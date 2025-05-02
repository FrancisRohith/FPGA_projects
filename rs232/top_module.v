module top_module(
	input clk, 
	input [7:0] TxD_data,
	input RxD,
	input TxD_start,
	input next,
	input reset,
	output TxD, 
	output reg [7:0] RxD_data1, 
	//output RxD_data_ready,
	output [6:0] num,
	output [3:0] anode);

  wire clk_d; 
  wire RxD_ready;
  
  wire [31:0] data_out1;
  wire [31:0] data_out2;
  
  clk_div cd(.clk(clk),.clk_d(clk_d));
  async_transmitter TX(.clk(clk),.TxD_start(TxD_start),.TxD_data(TxD_data),.TxD(TxD));
  async_receiver RX(.clk(clk),.RxD_ready(RxD_ready),.RxD(RxD),.reset(reset), .data_out1(data_out1), .data_out2(data_out2), .RxD_data(RxD_data));
  display d(.clk(clk_d), .RxD_ready(RxD_ready),.next(next), .data_out1(data_out1), .data_out2(data_out2), .anode(anode), .num(num));
    
  always @(*)
  	RxD_data1 = data_out2[7:0];
  
endmodule
