module control_calculate(inst, _type, ctl);
	/**
	* this is a combinational logic block
	* translating instructions to actual enable (and select) signals
	* in the calculation phase. What does this phase include?
	* - selecting the right rs1, rs2, and imm values to put in the alu
	* - select whether the memory or branch manager is enabled
	* the actual calculate signal happens on the negative edge so there is enough time to propagate. it
	* - sends the memory request to read/write data
	* - checks the branching condition, updating the pc as necessary
	*/
	parameter CTL_CAL = 5; 
	parameter REG1_CTL = 0; parameter REG2_CTL = 1; parameter IMM_CTL = 2; parameter RAMIN_CTL = 3; parameter BRCH_CTL = 4;
	input [31:0] inst;
	input [3:0] _type;
	output reg[CTL_CAL-1:0] ctl;
	
	initial begin
		ctl = 0;
	end
	
	always @(_type) begin
		case (_type)
			4'b0001: begin ctl = 1 << REG1_CTL | 1 << IMM_CTL; end //imm to register
			4'b0010: begin ctl = 1 << REG1_CTL | 1 << REG2_CTL; end //reg to reg
			4'b0011: begin ctl = 1 << REG1_CTL | 1 << REG2_CTL | 1 << BRCH_CTL; end //branch, but ofc rs1 and rs2 still used
			4'b0100: begin ctl = 1 << REG1_CTL | 1 << RAMIN_CTL; end //load
			4'b0101: begin ctl = 1 << REG1_CTL | 1 << REG2_CTL | 1 << RAMIN_CTL; end //store
			4'b0110: begin ctl = 1 << BRCH_CTL; end //jal, imm is passed to the pc directly
			4'b0111: begin ctl = 1 << REG1_CTL | 1 << BRCH_CTL; end //jalr
			4'b1000: begin ctl = 1 << IMM_CTL; end //lui is actually just using the alu again
			4'b1001: begin ctl = 0; end //auipc
			4'b1010: begin ctl = 0; end //halt
			4'b0000: begin ctl = 0; end //default
		endcase
	end
	
endmodule