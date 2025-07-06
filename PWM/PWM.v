module clk_div(
	input clk,
	output clk_out);
	reg [18:0] cntr;
	always @(posedge clk)
		cntr <= cntr + 1;
	assign clk_out = cntr[18];
endmodule

module PWM(
    input clk,
    input inc,
    input dec,
    output pwm_out
    );
	 
	clk_div cd(.clk(clk), .clk_out(slow_clk));
	
	reg [6:0] cntr = 0;
	reg [6:0] pulse_width = 0;
	
	parameter max_count = 7'b1100100;
	
	always @(posedge slow_clk)
	  cntr <= (cntr == max_count) ? 0 : cntr + 1;
		  
	always @(posedge slow_clk) 
	  if(inc && (pulse_width < max_count))
			pulse_width <= pulse_width + 1; 
	  else if(dec && (pulse_width > 0))
			pulse_width <= pulse_width - 1; 
	  else
			pulse_width <= pulse_width;       
  
  assign pwm_out = (pulse_width > cntr);
  
endmodule
