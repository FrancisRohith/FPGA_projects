module clk_div #(parameter div = 12) (input clk, output clk_d);
	reg [26:0] s;
	always @(posedge clk)
		s <= s+1;
	assign clk_d = s[div];
endmodule
