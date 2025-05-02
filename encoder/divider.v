module divider (
	input [20:0] Q, 
	input [11:0] M, 
	output reg [8:0] Quo,
	output reg [8:0] Rem);
	
	reg [20:0] a1, p1;
	reg [11:0] b1;
	integer i;
	
	always @(Q, M) begin
		a1 = Q;
		b1 = M;
		p1 = 0;
		for(i=0; i<21; i=i+1) begin
			p1 = {p1[19:0], a1[20]};
			a1[20:1] = a1[19:0];
			p1 = p1-b1;
			if(p1[20] == 1) begin
				a1[0] = 0;
				p1 = p1 + b1;
				end
			else
				a1[0] = 1;
		end
		Quo = a1;
		Rem = p1; 
		end
endmodule
