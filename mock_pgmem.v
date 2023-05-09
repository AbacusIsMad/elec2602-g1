module mock_pgmem(pc, clk, out);

	input [31:0] pc;
	input clk;
	output reg[31:0] out = 0;
	
	always @(posedge clk) begin
		case (pc)
			0: out = 32'h7ff00113;
			4: out = 32'h00c000ef;
			8: out = 32'h000017b7;
			12: out = 32'h80078623;
			
			16: out = 32'h000017b7;
			20: out = 32'h04800713;
			24: out = 32'h80e78023;
			28: out = 32'h00000513;
			32: out = 32'h00008067;
		endcase
	end

endmodule