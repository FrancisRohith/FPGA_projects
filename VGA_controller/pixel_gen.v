module pixel_gen(
	input video_on,
	input [9:0] x,
	input [9:0] y,
	output reg [7:0] rgb
    );
	
	parameter GREEN  = 8'h29;
	parameter BLUE   = 8'hA2;
	parameter YELLOW = 8'h5F;
	parameter BLACK  = 8'h00;
	
	wire bottom_green_on, top_black_on, left_green_on, right_green_on;
	wire upper_green_on, upper_yellow_on, lower_yellow_on;
	wire home1_on, home2_on, home3_on, home4_on, home5_on;
	wire wall1_on, wall2_on, wall3_on, wall4_on;
	wire street_on, water_on;
	
	assign bottom_green_on = ((x >= 0) && (x < 640) && (y >= 452) && (y < 480));
	assign top_black_on = ((x >= 0) && (x < 640) && (y >= 0) && (y < 32));
	assign left_green_on = ((x >= 0) && (x < 32) && (y >= 32) && (y < 452));
	assign right_green_on = ((x >= 608) && (x < 640) && (y >= 32) && (y < 452));
	assign upper_green_on = ((x >= 32) && (x < 608) && (y >= 32) && (y < 36));
	assign upper_yellow_on = ((x >= 32) && (x < 608) && (y >= 420) && (y < 452));
	assign lower_yellow_on = ((x >= 32) && (x < 608) && (y >= 420) && (y < 452));
	assign home1_on = ((x >= 32) && (x < 96) && (y >= 36) && (y < 68));
	assign wall1_on = ((x >= 96) && (x < 160) && (y >= 36) && (y < 68));
	assign home2_on = ((x >= 160) && (x < 224) && (y >= 36) && (y < 68));
	assign wall2_on = ((x >= 224) && (x < 288) && (y >= 36) && (y < 68));
	assign home3_on = ((x >= 288) && (x < 352) && (y >= 36) && (y < 68));
	assign wall3_on = ((x >= 352) && (x < 416) && (y >= 36) && (y < 68));
	assign home4_on = ((x >= 416) && (x < 480) && (y >= 36) && (y < 68));
	assign wall4_on = ((x >= 480) && (x < 544) && (y >= 36) && (y < 68));
	assign home5_on = ((x >= 544) && (x < 608) && (y >= 36) && (y < 68));
	assign street_on = ((x >= 32) && (x < 608) && (y >= 260) && (y < 420));
	assign water_on = ((x >= 32) && (x < 608) && (y >= 68) && (y < 228));
	
	always @*
		if(~video_on)
			rgb = BLACK;
		else
			if(bottom_green_on)
				rgb = GREEN;
			else if(top_black_on)
				rgb = BLACK;
			else if(left_green_on)
				rgb = GREEN;
			else if(right_green_on)
				rgb = GREEN;
			else if(upper_green_on)
				rgb = GREEN;
			else if(upper_yellow_on)
            rgb = YELLOW;
			else if(lower_yellow_on)
				rgb = YELLOW;
			else if(home1_on)
				rgb = BLUE;
			else if(home2_on)
				rgb = BLUE;
			else if(home3_on)
				rgb = BLUE;
			else if(home4_on)
				rgb = BLUE;
			else if(home5_on)
				rgb = BLUE;
			else if(wall1_on)
            rgb = GREEN;
			else if(wall2_on)
				rgb = GREEN;
			else if(wall3_on)
				rgb = GREEN;
			else if(wall4_on)
				rgb = GREEN;
			else if(street_on)
				rgb = BLACK;
			else if(water_on)
				rgb = BLUE;
			
				
endmodule
