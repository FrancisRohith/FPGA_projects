module clk_div #(parameter div = 12) (input clk, output reg clk_d);
	reg [26:0] s;
	always @(posedge clk) begin
		s<=s+1;
		clk_d<=s[div]; end
endmodule

module counter(
  input sw,
	input clk,
	output [15:0] counter
   );

	wire clk_d;
	clk_div #(25) d (.clk(clk), .clk_d(clk_d));
	
	reg [5:0] cntr = 0;
	reg [5:0] temp; 
	reg [3:0] ones;
	reg [3:0] tens;
	reg digit_state;

	always @(posedge clk_d)
		if (sw) cntr <= cntr + 1;
		
	always @(cntr) begin
		temp = cntr;
		ones = 0;
		tens = 0;
		
		if(temp>=90) begin temp=temp-10; tens=tens+1; end
		if(temp>=80) begin temp=temp-10; tens=tens+1; end
		if(temp>=70) begin temp=temp-10; tens=tens+1; end
		if(temp>=60) begin temp=temp-10; tens=tens+1; end
		if(temp>=50) begin temp=temp-10; tens=tens+1; end
		if(temp>=40) begin temp=temp-10; tens=tens+1; end
		if(temp>=30) begin temp=temp-10; tens=tens+1; end
		if(temp>=20) begin temp=temp-10; tens=tens+1; end
		if(temp>=10) begin temp=temp-10; tens=tens+1; end
		ones = temp;
		end
	assign counter[15:8] = tens + 8'd48;
	assign counter[7:0] = ones + 8'd48;

endmodule
