 `timescale 1ns / 1ps  

module alu_TB;
//Inputs  (not sure if reg or wire)
 reg[7:0] A,B;
 reg[3:0] code;

 //output
 reg[7:0] out;
 reg[3:0] count;

 alu#(.LEN(8)) alutest(.A(A),.B(B),.code(code),.out(out));

initial begin
    count = 4'b0000;
end

always begin
    #50
    count=count+1;
end


always@(count)begin
    case(count)
        4'b0000: begin A = 4; B = 1; code = 0; end
        4'b0001: begin A = 4; B = 1; code = 1; end
        4'b0010: begin A = 4; B = 1; code = 2; end
        4'b0011: begin A = 4; B = 1; code = 3; end
        4'b0100: begin A = 4; B = 1; code = 4; end
        4'b0101: begin A = 4; B = 1; code = 5; end
        4'b0110: begin A = 4; B = 1; code = 6; end
        4'b0111: begin A = 4; B = 1; code = 7; end
        4'b1000: begin A = 4; B = 1; code = 8; end
        default: begin A = 7; B = 9; code = 9; end
    endcase
end

endmodule

//still hava to test the code!