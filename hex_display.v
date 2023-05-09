module hex_display(input[3:0] data, output reg[6:0] disp, input block);
	always @(data) begin
		if (block == 1'b1) begin
			disp = 7'b1111111; //don't show anything
		end else begin
			case (data)
				4'b0000 : begin disp = 7'b1000000; end
				4'b0001 : begin disp = 7'b1111001; end
				4'b0010 : begin disp = 7'b0100100; end
				4'b0011 : begin disp = 7'b0110000; end
				4'b0100 : begin disp = 7'b0011001; end
				4'b0101 : begin disp = 7'b0010010; end
				4'b0110 : begin disp = 7'b0000010; end
				4'b0111 : begin disp = 7'b1111000; end
				4'b1000 : begin disp = 7'b0000000; end
				4'b1001 : begin disp = 7'b0010000; end
				4'b1010 : begin disp = 7'b0001000; end
				4'b1011 : begin disp = 7'b0000011; end
				4'b1100 : begin disp = 7'b0100111; end
				4'b1101 : begin disp = 7'b0100001; end
				4'b1110 : begin disp = 7'b0000110; end
				4'b1111 : begin disp = 7'b0001110; end
			endcase
		end
	end
endmodule