module display(
	input clk,
	input RxD_ready,
	input [31:0] data_out1,
	input [31:0] data_out2,
	input next,
	output reg [6:0] num,
	output reg [3:0] anode
);
	reg [1:0] display_state = 0;
	reg [7:0] data;
	reg [31:0] data_15;
	
	always @(*) begin
	case(next)
	0: begin data_15 = data_out1; end
	1: begin data_15 = data_out2;end
	endcase
	end
	
	always @(posedge clk)
		case(display_state)
		0: display_state <= 1;
		1: display_state <= 2;
		2: display_state <= 3;
		3: display_state <= 0;
		default: display_state <= 0;
		endcase
		//display_state <= display_state + 1;
	always @(*) begin
		case(display_state)
			0: begin anode = 4'b1110; data = data_15[23:16]; end
			1: begin anode = 4'b1101; data = data_15[7:0]; end
			3: begin anode = 4'b1011; data = data_15[31:24];   end
			2: begin anode = 4'b0111; data = data_15[15:8];  end
			default: begin anode = 4'b1111; data = 8'h00; end
		endcase
	end
	always @(posedge clk) begin
		case(data)
			8'd48: num <= 7'b1000000;
			8'd49: num <= 7'b1111001;
			8'd50: num <= 7'b0100100;
			8'd51: num <= 7'b0110000;
			8'd52: num <= 7'b0011001;
			8'd53: num <= 7'b0010010;
			8'd54: num <= 7'b0000010;
			8'd55: num <= 7'b1111000;
			8'd56: num <= 7'b0000000;
			8'd57: num <= 7'b0010000;
			default: num <= 7'b1000000;
		endcase
	end
endmodule
