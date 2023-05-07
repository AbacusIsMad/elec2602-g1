module control_write(inst, _type, ctl);
	/**
	* this is a combinational logic block
	* translating instructions to write signals. this mainly deals with registers.
	* write happens with the positive edge and it updates the values in the registers.
	* it also sends control signals to the alu, ram and pc and decides which one to put on the bus.
	*/
	parameter CTL_WRI = 4;
	parameter ALU_CTL = 0; parameter RAMOUT_CTL = 1; parameter PC_CTL = 2; parameter REG_CTL = 3;
	input [31:0] inst;
	input [3:0] _type;
	output reg[CTL_WRI-1:0] ctl;
	
	initial begin
		ctl = 0;
	end
	
	always @(_type) begin
		case (_type)
			4'b0001: begin ctl = 1 << ALU_CTL | 1 << REG_CTL; end //imm to register
			4'b0010: begin ctl = 1 << ALU_CTL | 1 << REG_CTL; end //reg to reg
			4'b0011: begin ctl = 0; end //branch, don't write to stuff
			4'b0100: begin ctl = 1 << RAMOUT_CTL | 1 << REG_CTL; end //load
			4'b0101: begin ctl = 0; end //store
			4'b0110: begin ctl = 1 << PC_CTL | 1 << REG_CTL; end //jal stores pc to rd
			4'b0111: begin ctl = 1 << PC_CTL | 1 << REG_CTL; end //same with jalr
			4'b1000: begin ctl = 1 << ALU_CTL | 1 << REG_CTL; end //lui
			4'b1001: begin ctl = 1 << REG_CTL | 1 << PC_CTL; end //auipc
			4'b1010: begin ctl = 0; end //halt
			4'b0000: begin ctl = 0; end //default
		endcase
	end
endmodule