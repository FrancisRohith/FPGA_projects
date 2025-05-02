module time_div(input clk, output reg clk_div);
	reg [21:0] s = 22'b0;
	always @(posedge clk) begin
		s <= s+1;
		clk_div <= s[12];
		end
endmodule

module seg7_display(
	input clk,
	input [8:0] angle,
	output reg [3:0] anode,
	output reg [6:0] num	
    );
	 
	 reg [3:0] num_reg;
	
	always @(num_reg)begin
			case(num_reg)
				4'd0: num <= 7'b1000000;
				4'd1: num <= 7'b1111001;
				4'd2: num <= 7'b0100100;
				4'd3: num <= 7'b0110000;
				4'd4: num <= 7'b0011001;
				4'd5: num <= 7'b0010010;
				4'd6: num <= 7'b0000010;
				4'd7: num <= 7'b1111000;
				4'd8: num <= 7'b0000000;
				4'd9: num <= 7'b0010000;
				default: num <= 7'b0000000;
			endcase
		end
		
	wire [3:0] hundreds, tens, ones;
	wire [6:0] Quo2, Rem1, Rem2, Quo3;
	divider div1(.Q(angle), .M(7'd100), .Quo(hundreds), .Rem(Rem1));
	divider div2(.Q(Rem1), .M(4'd10), .Quo(tens), .Rem(Rem2));
	divider div3(.Q(angle), .M(4'd10), .Quo(Quo3), .Rem(ones));
	
	reg [2:0] state=0;
	parameter S0 = 0, S1 =1, S2 =2, S3 =3, S4 =4;
	wire clk_div;
   time_div td(.clk(clk),.clk_div(clk_div));
   always @(posedge clk_div) begin
		case (state)
		S0: begin state <= S1;end 
		S1: begin state <= S2; end
		S2: begin state <= S3; end
		S3: begin state <= S0; end
		S4:  begin state <= S0;  end
		default: state <= S0;
		endcase 
		end
	always @(state) begin
	case (state)
	S0: begin anode <= 4'b0111; num_reg <= ones; end
	S1: begin anode <= 4'b1011; num_reg <= tens; end
	S2: begin anode <= 4'b1101; num_reg <= hundreds; end
	S3: begin anode <= 4'b1110; num_reg <= 0; end
	S4: begin anode <= 4'b1111; num_reg <= 0; end
	default: begin anode <= 4'b1111; num_reg <= 0; end 
	endcase 
	end
	
endmodule
