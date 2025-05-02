module async_transmitter(
	input clk,
   input sw,
	input [15:0] TxD_data,
	output TxD
);

parameter ClkFrequency = 50000000;	
parameter Baud = 115200;
parameter BaudGeneratorAccWidth = 16;
parameter BaudGeneratorInc = ((Baud<<(BaudGeneratorAccWidth-4))+(ClkFrequency>>5))/(ClkFrequency>>4);

reg [BaudGeneratorAccWidth:0] BaudGeneratorAcc;

always @(posedge clk)
  BaudGeneratorAcc <= BaudGeneratorAcc[BaudGeneratorAccWidth-1:0] + BaudGeneratorInc;

wire BitTick = BaudGeneratorAcc[BaudGeneratorAccWidth];
reg [3:0] TxD_state = 0;
wire TxD_ready = (TxD_state==4'b0100);
//assign TxD_busy = ~TxD_ready;

reg [7:0] prev, curr = 0;
reg [7:0] TxD_shift;
reg shift;
reg digit_select = 0;
reg sw_prev;
wire sw_edge = sw & ~sw_prev;

always @(posedge clk)
    sw_prev <= sw;

reg [7:0] mem [15:0];
reg [3:0] mem_addr = 0;
initial begin
	mem[0] = 8'd72;
	mem[1] = 8'd69;
	mem[2] = 8'd76;
	mem[3] = 8'd76;
	mem[4] = 8'd79;
	mem[5] = 8'd32;
	mem[6] = 8'd87;
	mem[7] = 8'd79;
	mem[8] = 8'd82;
	mem[9] = 8'd76;
	mem[10] = 8'd68;
	mem[11] = 8'd32;
	mem[12] = 8'd33; 
	mem[13] = 8'd33;
	mem[14] = 8'd33;
	mem[15] = 8'd33;
end

always @(*) 
  shift = (curr!= prev);

always @(posedge clk)
begin 
	prev <= curr;	
	curr <= digit_select ? TxD_data[15:8] : TxD_data[7:0];
// if(TxD_ready)
//	curr <= mem[mem_addr];
	if(TxD_ready) 
	TxD_shift <= curr; 
	if(TxD_state[3] & BitTick)
		TxD_shift <= (TxD_shift >> 1);
	case(TxD_state)
		4'b0000: if(shift && sw) begin 
						TxD_state <= 4'b0100;
						digit_select <= 1;
						end
//		4'b0000: if(sw_edge) TxD_state <= 4'b0100;					

		4'b0100: if(BitTick) TxD_state <= 4'b1000;  // start bit
		4'b1000: if(BitTick) TxD_state <= 4'b1001;  // bit 0
		4'b1001: if(BitTick) TxD_state <= 4'b1010;  // bit 1
		4'b1010: if(BitTick) TxD_state <= 4'b1011;  // bit 2
		4'b1011: if(BitTick) TxD_state <= 4'b1100;  // bit 3
		4'b1100: if(BitTick) TxD_state <= 4'b1101;  // bit 4
		4'b1101: if(BitTick) TxD_state <= 4'b1110;  // bit 5
		4'b1110: if(BitTick) TxD_state <= 4'b1111;  // bit 6
		4'b1111: if(BitTick) TxD_state <= 4'b0010;  // bit 7
		4'b0010: if(BitTick) TxD_state <= 4'b0011;  // stop1
		4'b0011: if(BitTick) 
						if(digit_select == 1) begin
							digit_select <= 0;
							TxD_state <= 4'b0100; end // stop2
						else TxD_state <= 4'b0000;
//		4'b0011: if(BitTick)
//						if(mem_addr<15) begin 
//							TxD_state <= 4'b0100;
//							mem_addr <= mem_addr + 1; end 
//					else TxD_state <= 4'b0000;

		default: if(BitTick) TxD_state <= 4'b0000;
	endcase
end

assign TxD = (TxD_state<4) | (TxD_state[3] & TxD_shift[0]);  // put together the start, data and stop bits

endmodule
