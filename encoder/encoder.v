module encoder(
	input clk,
	input A,
	input B,
	input reset,
	output [8:0] angle,
	output reg up_count
    );
	 
	wire posedge_A;
	wire negedge_A;
	wire posedge_B;
	wire negedge_B;
	
	reg [11:0] counter = 0;
	reg A_d;
	reg B_d; 
	 
	always @(posedge clk) begin
		A_d <= A;
		B_d <= B;
		end
	

	assign posedge_A = ~A_d & A;
	assign negedge_A = A_d & ~A;
	assign posedge_B = ~B_d & B;
	assign negedge_B = B_d & ~B;
	
	parameter idle = 3'b000, F1 = 3'b001, F2 = 3'b010, F3 = 3'b011,
									 R1 = 3'b101, R2 = 3'b110, R3 = 3'b111;
		
	reg [3:0] F, R;
	always @(posedge clk) begin
	if(~A & posedge_B) begin F[0] <= 1; R <= 4'b0; end
	if(posedge_A & B)  begin F[1] <= 1; R <= 4'b0; end
	if(A & negedge_B)  begin F[2] <= 1; R <= 4'b0; end
	if(negedge_A & ~B) begin F[3] <= 1; R <= 4'b0; end
	if(posedge_A & ~B) begin R[0] <= 1; F <= 4'b0; end
	if(posedge_B & A)  begin R[1] <= 1; F <= 4'b0; end
	if(negedge_A & B)  begin R[2] <= 1; F <= 4'b0; end
	if(~A & negedge_B) begin R[3] <= 1; F <= 4'b0; end
	if(R == 4'b1111) up_count <= 0;
	else if(F == 4'b1111) up_count <= 1;
	else up_count <= up_count;
	end
		
	always @(posedge clk or posedge reset) begin
    if (reset)
        counter <= 0;
    else if (posedge_A | negedge_A | posedge_B | negedge_B) begin
        if (up_count) begin
            if (counter == 12'd4000)
                counter <= 0;
            else
                counter <= counter + 1;
        end else if(~up_count) begin
            if (counter == 0)
                counter <= 12'd4000;
            else
                counter <= counter - 1;
        end
		end
	end

	
	wire [8:0] Quo, Rem;
	reg [20:0] temp; 
	divider div(.Q(temp),.M(12'd4000), .Quo(Quo), .Rem(Rem));
	always @(*)begin
		temp = counter * 360;
		end
	assign angle = Quo;
	
endmodule
