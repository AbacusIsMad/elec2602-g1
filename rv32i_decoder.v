module rv32i_decoder(inst, imm, type);
	input[31:0] inst;
	output reg[31:0] imm;
	output reg[3:0] type;
	
	always @(inst) begin
		case (inst[6:0])
			7'b0010011: begin type = 4'b0001; imm = {{21{inst[31]}}, inst[30:20]}; end //imm to register
			7'b0110011: begin type = 4'b0010; imm = 0; end //reg to reg
			7'b1100011: begin type = 4'b0011; imm = {{20{inst[31]}}, inst[7], inst[30:25], inst[11:8], 1'b0}; end //branch
			7'b0000011: begin type = 4'b0100; imm = {{21{inst[31]}}, inst[30:20]}; end //load
			7'b0100011: begin type = 4'b0101; imm = {{21{inst[31]}}, inst[30:25], inst[11:7]}; end //store
			7'b1101111: begin type = 4'b0110; imm = {{12{inst[31]}}, inst[19:12], inst[20], inst[30:21], 1'b0}; end //jal
			7'b1100111: begin type = 4'b0111; imm = {{21{inst[31]}}, inst[30:20]}; end  //jalr
			7'b0110111: begin type = 4'b1000; imm = {inst[31:12], 12'b000000000000}; end //lui
			7'b0010111: begin type = 4'b1001; imm = {inst[31:12], 12'b000000000000}; end //auipc
			7'b1111111: begin type = 4'b1010; imm = 0; end //halt, stay at this instruction
			default   : begin type = 4'b0000; imm = 0; end //default value, don't do anything!
		endcase
	end
	
	

endmodule