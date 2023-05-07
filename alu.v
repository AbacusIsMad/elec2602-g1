module alu(A, B, out, code, _type);
	parameter LEN = 8;

	input[LEN-1:0] A,B;
	input[3:0] code;
	input[3:0] _type;

	output reg[LEN-1:0] out;

	reg[3:0] code2;
	
	always @(code, _type) begin
		if (_type == 4'b1000) begin //lui
			code2= 4'b1111;
		end else if (_type == 4'b0001) begin //imm to register
			if (code[2:0] == 3'b101) begin
				code2 = {code[3], code[2:0]};
			end else begin
				code2 = {1'b0, code[2:0]};
			end
		end else begin //reg to reg
			code2 = {code[3], code[2:0]};
		end
	end
	
	always@(A, B, _type, code2) begin
		case(code2)
			4'b0000: out = A + B; //Addition
			4'b1000: out = A - B; //Subtration
			4'b0010: out = $signed(A) < $signed(B) ? 1 : 0; //slt
			4'b0011: out = A < B ? 1 : 0; //sltu
			4'b0100: out = A ^ B; //XOR
			4'b0110: out = A | B; //OR
			4'b0111: out = A & B; //AND
			4'b0001: out = A << (B & 32'h0000001f); //shift left
			4'b0101: out = A >> (B & 32'h0000001f); //shift right
			4'b1101: out = $signed(A) >>> (B & 32'h0000001f); //arithmetic shift right
			4'b1111: out = B; //lui
			default: out = 0; //defualt case
		endcase
	end
endmodule

//still hava to test the code!
//might have to add a carry flag and a zero flag



