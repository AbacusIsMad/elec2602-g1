module branch_manager(val1, val2, op, ,_type, out);
	parameter WIDTH = 32;
	
	input[WIDTH-1:0] val1, val2;
	input[2:0] op;
	input[3:0] _type;
	output wire out;
	
	wire[2:0] op2;
	assign op2 = _type[3:1] == 3'b011 ? 3'b010 : op[2:0];
	
	reg tmp;
	always @(val1, val2, op2) begin
		case (op2[2:1])
			2'b00: tmp = (val1 == val2) ? 1'b1 : 1'b0; //eq
			2'b10: tmp = ($signed(val1) < $signed(val2)) ? 1'b1 : 1'b0; //blt
			2'b11: tmp = (val1 < val2) ? 1'b1 : 1'b0; //bltu
			//2'b01: tmp = 1;
			default: tmp = 1'b1;
		endcase
	end
	
	assign out = tmp ^ op2[0]; //switch for ne, bge, bgeu

endmodule