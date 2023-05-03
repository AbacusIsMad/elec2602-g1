module alu(A, B, out, code);
    parameter LEN = 8;
    
    input[LEN-1:0] A,B;
    input[3:0] code;

    output reg[LEN-1:0] out;

    always@(*) begin
        case(code)
            4'b0000: out=A+B; //Addition
            4'b0001: out=A-B; //Subtration (maybe remove it later)
            4'b0010: out=A*B; //Multiplication
            4'b0011: out=A/B; //Division (maybe remove it)
            4'b0100: out=A^B; //XOR
            4'b0101: out=A&B; //AND
            4'b0110: out=A|B; //OR
            4'b0111: out=A<<1; //logical shift left
            4'b1000: out=A>>1; //logical shift right
            default: out=[len-1]'b0; //defualt case
        endcase
    end
endmodule

//still hava to test the code!
//might have to add a carry flag and a zero flag



