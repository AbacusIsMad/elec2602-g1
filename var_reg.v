module var_reg(d, clk, enable, q, reset);
	parameter LEN = 8;

	input[LEN-1:0] d;
	output reg[LEN-1:0] q;
	input clk, reset, enable;
	
	initial begin
		q <= 0;
	end
	
	always @(posedge clk or posedge reset) begin
		
		if (reset) begin
			q <= 0;
		end else begin
			if (enable) begin
				q <= d;
			end else begin
				q <= q;
			end
		end
	end

endmodule