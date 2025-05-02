module async_receiver(
	input clk,
	input RxD,
	input reset,
	output RxD_ready,
	output reg [31:0] data_out1 = 0,
	output reg [31:0] data_out2 = 0,
	output reg [7:0] RxD_data
);
  
parameter ClkFrequency = 50000000;	// 25MHz
parameter Baud = 115200;
parameter BaudGeneratorAccWidth = 16;
parameter BaudGeneratorInc = ((Baud<<(BaudGeneratorAccWidth-4))+(ClkFrequency>>5))/(ClkFrequency>>4);

reg [BaudGeneratorAccWidth:0] BaudGeneratorAcc;
always @(posedge clk)
  BaudGeneratorAcc <= BaudGeneratorAcc[BaudGeneratorAccWidth-1:0] + BaudGeneratorInc;

wire BitTick = BaudGeneratorAcc[BaudGeneratorAccWidth];
reg [3:0] RxD_state = 0;
reg valid = 1'b1;
//reg [7:0] RxD_data = 8'b0;
reg storage_state = 0;

assign RxD_ready = (RxD_state==4'b0011);

always @(posedge clk) begin
	case(RxD_state)
	4'b0000: if(~RxD && valid) RxD_state <= 4'b0100;
	4'b0100: if(BitTick) RxD_state <= 4'b1000;
	4'b1000: if(BitTick) RxD_state <= 4'b1001;  // bit 0
	4'b1001: if(BitTick) RxD_state <= 4'b1010;  // bit 1
	4'b1010: if(BitTick) RxD_state <= 4'b1011;  // bit 2
	4'b1011: if(BitTick) RxD_state <= 4'b1100;  // bit 3
	4'b1100: if(BitTick) RxD_state <= 4'b1101;  // bit 4
	4'b1101: if(BitTick) RxD_state <= 4'b1110;  // bit 5
	4'b1110: if(BitTick) RxD_state <= 4'b1111;  // bit 6
	4'b1111: if(BitTick) RxD_state <= 4'b0010;  // bit 7
	4'b0010: if(BitTick) begin 
				RxD_state <= 4'b0011;
				if (RxD_data == 44) storage_state <= storage_state + 1;
				else if (RxD_data == 64) valid = 0;
				case(storage_state)
				0: if (RxD_data != 44 && RxD_data != 64) data_out1 <=  {data_out1[23:0], RxD_data} ;
				1: if (RxD_data != 44 && RxD_data != 64) data_out2 <=  {data_out2[23:0], RxD_data} ; 
				endcase
					end 
	4'b0011: if(BitTick) RxD_state <= 4'b0000;  
	default: if(BitTick) RxD_state <= 4'b0000;
	endcase
	if (reset) begin data_out1 <= 0; data_out2 <= 0; valid = 1; end
	end

always @(posedge clk) 
	if (BitTick && RxD_state[3]) RxD_data <= {RxD, RxD_data[7:1]};
endmodule

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
