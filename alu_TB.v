 `timescale 1ns / 1ps  

module alu_TB;
//Inputs  (not sure if reg or wire)
 reg[7:0] A,B;
 reg[3:0] code, _type;

 //output
 wire[7:0] out;
 reg[3:0] count;

 alu#(.LEN(8)) alutest(.A(A),.B(B), .out(out), .code(code), ._type(_type));

initial begin
    count = 4'b0000;
end

always begin
    #50
    count=count+1;
end


always@(count)begin
    case(count)
        4'b0000: begin A = 4; B = 1; code = 4'b0000; _type = 4'b0010; end
        4'b0001: begin A = 4; B = 5; code = 4'b1000; end
        4'b0010: begin A = 4; B = 8'b11111111; code = 4'b0010; end
        4'b0011: begin A = 4; B = 8'b11111111; code = 4'b0011; end
        4'b0100: begin A = 6; B = 3; code = 4'b0100; end
        4'b0101: begin A = 6; B = 3; code = 4'b0110; end
        4'b0110: begin A = 6; B = 3; code = 4'b0111; end
        4'b0111: begin A = 8'b10101010; B = 1; code = 4'b0001; end
        4'b1000: begin A = 8'b10101010; B = 1; code = 4'b0101; end
        4'b1001: begin A = 8'b10101010; B = 1; code = 4'b1101; end
		  4'b1010: begin A = 3; B = 10; code = 4'b1111; end
    endcase
end

endmodule