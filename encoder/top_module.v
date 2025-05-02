module top_module(
	input clk,
	input A,
	input B,
	input reset,
	output [1:0] LED,
	output [3:0] anode,
	output [7:0] angle_out,
	output [7:0] num
    );
  
	wire [8:0] angle; 
	wire [7:0] encout;
	assign angle_out = angle[7:0];
	encoder enc(.clk(clk), .A(A), .B(B), .reset(reset), .angle(angle), .encout(encout), .LED(LED));
	seg7_display seg7(.clk(clk), .reset(reset), .angle(angle), .anode(anode), .num(num));

endmodule
