module PWM_top(
	input clk,
	input inc,
	input dec,
	input start,
	output pwm_out,
	output pwm_light);
	
	parameter max_count = 7'b1100100;
	
	reg [25:0] cntr = 0;
	reg clk_0_5Hz;
	reg [1:0] sel = 2'b0;
	wire pwm_0, pwm_1, pwm_2;
	wire clk_5000Hz;
	
	always @(posedge clk)
		if(cntr == 26'd50000000) begin
			clk_0_5Hz <= ~clk_0_5Hz;
			cntr <= 0;
			end
		else 
			cntr <= cntr + 1;
			
	clk_div cd(.clk(clk), .clk_5000Hz(clk_5000Hz));	
	PWM #(max_count) pwm (.clk(clk_5000Hz), .inc(inc), .dec(dec), .pwm_out(pwm_0));
	PWM_2 pwm1 (.clk(clk_5000Hz), .pulse_width(7'b0001010), .pwm_out(pwm_1));
	PWM_2 pwm2 (.clk(clk_5000Hz), .pulse_width(7'b0000101), .pwm_out(pwm_2));
		
	always @(posedge clk_0_5Hz)
		if(start &&(sel == 2'b00))
			sel <= 2'b01;
		else if(sel == 2'b01)
			sel <= 2'b10;
		else if(sel == 2'b10)
			sel <= 2'b11;
		else if(sel == 2'b11)
			sel <= 2'b11;
		
	assign pwm_out = (sel == 2'b01) ? pwm_1 :
                 (sel == 2'b10) ? pwm_2 :
                 (sel == 2'b11) ? pwm_0 : 1'b0;
	assign pwm_light = pwm_out;		
endmodule

module clk_div (
	input clk,
	output clk_5000Hz);
	
	reg [18:0] cntr;
	reg clk_reg;
	
	always @(posedge clk)
		if(cntr == 19'd4999) begin
			cntr <= 0;
			clk_reg <= ~clk_reg;
			end
		else 
			cntr <= cntr + 1;
	assign clk_5000Hz = clk_reg;
	
endmodule

module PWM #(parameter max_count = 7'b1100100)(
    input clk,
    input inc,
    input dec,
    output pwm_out
    );

	reg [6:0] cntr = 0;
	reg [6:0] pulse_width = 0;
	wire tick;
	//parameter max_count = 7'b1100100;

	always @(posedge clk)
	cntr <= (cntr == max_count) ? 0 : cntr + 1;
	
	reg [9:0] s;
	always @(posedge clk)
		if(inc | dec)
			s <= s + 1;
		else
			s <= 0;
	assign tick = (s == 10'd1000);
	always @(posedge clk) 
	if(inc && (pulse_width < max_count) && tick)
		pulse_width <= pulse_width + 1; 
	else if(dec && (pulse_width > 0) && tick)
		pulse_width <= pulse_width - 1; 
	else
		pulse_width <= pulse_width;       

	assign pwm_out = (pulse_width > cntr);
	
endmodule

module PWM_2(
	input clk,
	input [6:0] pulse_width,
	output pwm_out);
	
	reg [6:0] cntr;
	
	always @(posedge clk)
		cntr <= (cntr == 7'b1100100) ? 0: cntr + 1;
		
	assign pwm_out = (pulse_width > cntr);
	
endmodule
