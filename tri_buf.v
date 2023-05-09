module tri_buf(in, out, enable);
	parameter LEN = 32;

	input[LEN-1:0] in;
	output reg[LEN-1:0] out;
	input enable;
	
	initial begin
		out = {(LEN){1'bz}};
	end
	
	always @(enable or in) begin
		
		if (enable) begin
			out = in;
		end else begin
			out = {(LEN){1'bz}};
		end
	end

endmodule