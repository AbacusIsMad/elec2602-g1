module gen_regs(in, clk, selectR, selectR2, selectW, reset, out, out2, enable);
	parameter WIDTH = 32;
	parameter SIZE = 32;
	
	input[WIDTH-1:0] in, selectR, selectR2, selectW; //two things for two busses, yay!
	input clk, reset, enable;
	output[WIDTH-1:0] out, out2;
	
	genvar i;
	generate
		for (i = 0; i < SIZE; i = i + 1) begin : create_regs
			wire[WIDTH-1:0] tmp_in;
			var_reg#(.LEN(WIDTH)) vr(.d(in), .clk(clk), .enable(selectW[i] & enable), .q(tmp_in), .reset(reset));
			tri_buf#(.LEN(WIDTH)) tr1(.in(i == 0 ? 0 : tmp_in), .out(out), .enable(selectR[i]));
			tri_buf#(.LEN(WIDTH)) tr2(.in(i == 0 ? 0 : tmp_in), .out(out2), .enable(selectR2[i]));
		end
	endgenerate

endmodule