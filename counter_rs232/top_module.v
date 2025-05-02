module top_module(
   input sw,
	input clk,
	output TxD,
	output [7:0] counter);
  
	wire [15:0] cnter;
	async_transmitter tx(.clk(clk),.sw(sw), .TxD_data(cnter), .TxD(TxD));
	counter cntr(.clk(clk), .sw(sw),.counter(cnter));
	assign counter = cnter[7:0];

endmodule
