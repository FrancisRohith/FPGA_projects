module top_module(
	input clk,
	input A,
	input B,
	input reset,
	output [3:0] anode,
	output [6:0] num, 
	output up_count
    );
	wire [8:0] angle;
	encoder enc(.A(A), .B(B), .clk(clk), .reset(reset), .angle(angle), .up_count(up_count));
	seg7_display seg7(.clk(clk), .angle(angle), .anode(anode), .num(num));
endmodule
