module pipeline(instF, instD, instC, instW, clk, reset);
	parameter WIDTH = 32;

	input[WIDTH-1:0] instF;
	output reg[WIDTH-1:0] instD, instC, instW;
	input clk, reset;
	
	always @(posedge clk) begin
		if (reset) begin
			instD <= 0;
			instC <= 0;
			instW <= 0;
		end else begin
			instW <= instC;
			instC <= instD;
			instD <= instF;
		end
	end

endmodule

module pipeline2(inst, clk, reset, instC, instW, typeC, typeW, immC, immW);

	parameter WIDTH = 32;
	input[WIDTH-1:0] inst;
	input clk, reset;
	output reg[3:0] typeC, typeW;
	output reg[WIDTH-1:0] immC, immW, instC, instW;
	
	wire[3:0] tempT;
	wire[WIDTH-1:0] tempI;
	rv32i_decoder decode(.inst(inst), .imm(tempI), .type(tempT));
	
	
	
	always @(posedge clk) begin
		if (reset) begin
			instC <= 0; instW <= 0;
			typeC <= 0; typeW <= 0;
			immC <= 0; immW <= 0;
		end else begin
			{instW, immW, typeW} <= {instC, immC, typeC};
			{instC, immC, typeC} <= {inst, tempI, tempT};
		end
	end
	

endmodule