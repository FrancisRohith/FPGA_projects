module PWM_tb;

    reg clk = 0;
    reg inc = 0;
    reg dec = 0;
    wire pwm_out;

    // Instantiate the DUT (Device Under Test)
    PWM uut (
        .clk(clk),
        .inc(inc),
        .dec(dec),
        .pwm_out(pwm_out)
    );

    // Clock generation: 10ns period (100 MHz)
    always #5 clk = ~clk;

    initial begin
        // Monitor the signals
        $monitor("Time=%0t | pulse inc=%b dec=%b pwm_out=%b", $time, inc, dec, pwm_out);

        // Initialize signals
        inc = 0; dec = 0;

        // Wait a few cycles
        #20;

        // Increase pulse width
        inc = 1;
        #100;
        inc = 0;

        // Wait and observe
        #200;

        // Decrease pulse width
        dec = 1;
        #50;
        dec = 0;

        // Wait and finish
        #200;

        $finish;
    end

endmodule
