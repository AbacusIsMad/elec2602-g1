module pc_manager(val1, imm, _type, clk, enable, branch, stop, pc, pc2, pcOut, breakPipe);

	input[31:0] val1, imm;
	input[3:0] _type;
	input clk, enable, branch, stop;
	
	output reg[31:0] pc = -4, pc2 = 0, pcOut = 0;
	output reg breakPipe = 0;
	
	always @(posedge clk) begin
		pc2 <= pc;
		
		if (stop) begin
			pc <= pc; //don't do anything
		end else if (enable & branch) begin
			if (_type == 4'b0111) begin
				pc <= val1 + imm; //jalr uses absolute addressses
			end else begin //normal branching uses relative ones.
				pc <= pc + imm - 4;
			end
			breakPipe <= 1;
		end else begin
			pc <= pc + 4;
			breakPipe <= 0;
		end
	end
	
	always @(pc2, _type, imm) begin
		case (_type)
			4'b1001: begin pcOut = pc2 + imm - 4; end //auipc
			default: begin pcOut = pc2; end //others for display. also used for jal, jalr
		endcase
	end

endmodule