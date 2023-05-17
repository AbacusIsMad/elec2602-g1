module pc_manager(val1, imm, _type, clk, reset, enable, branch, stop, pc, pc2, pcOut, breakPipe,
	pc_override, inst_data, inst_addr //these are for the setup sequence
	);

	input[31:0] val1, imm;
	input[3:0] _type;
	input clk, reset, enable, branch, stop;
	
	//pc starts at 4 below 
	output reg[31:0] pc = -2052, pc2 = 0, pcOut = 0;
	output reg breakPipe = 0;
	output reg pc_override = 1;
	output reg[31:0] inst_addr = 0;
	output wire[31:0] inst_data;
	
	inst_rom rom(.clk(~clk), .addr(pc[10:2] - 1), .out(inst_data));
	//made_rom rom(.clock(~clk), .address(pc[10:2] - 1), .q(inst_data));
	
	//pc increments on positive edge
	always @(posedge clk or posedge reset) begin
		if (reset) begin //resetting
			pc <= -2052;
			breakPipe <= 1;
			inst_addr <= 0;
		end else begin //normal sequence
			pc2 <= pc;
			
			if (pc_override) begin
				if (pc >= 32'hfffffffc) begin //switch to normal
					pc_override <= 0;
				end else begin //get data, then send it
					pc <= pc + 4;
					inst_addr <= {21'b0, pc[10:0]};
				end
			end else if (stop) begin
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
	end
	
	always @(pc2, _type, imm) begin
		case (_type)
			4'b1001: begin pcOut = pc2 + imm - 4; end //auipc
			default: begin pcOut = pc2; end //others for display. also used for jal, jalr
		endcase
	end

endmodule