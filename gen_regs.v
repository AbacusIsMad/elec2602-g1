module gen_regs(in, clk, select, select2, reset, out, out2, isIn);
	parameter WIDTH = 32;
	parameter SIZE = 32;
	
	input[WIDTH-1:0] in, select, select2; //two things for two busses, yay!
	input clk, reset, isIn;
	output[WIDTH-1:0] out, out2;
	
	genvar i;
	generate
		for (i = 0; i < SIZE; i = i + 1) begin : create_regs
			wire[WIDTH-1:0] tmp_in;
			var_reg#(.LEN(WIDTH)) vr(.d(in), .clk(clk), .enable(select[i] & isIn), .q(tmp_in), .reset(reset));
			tri_buf#(.LEN(WIDTH)) tr1(.in(tmp_in), .out(out), .enable(select[i]));
			tri_buf#(.LEN(WIDTH)) tr2(.in(tmp_in), .out(out2), .enable(select2[i]));
		end
	endgenerate

endmodule