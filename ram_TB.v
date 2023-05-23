module ram_TB();

	reg [7:0] count;
	reg clock;
	reg we = 0, enable = 0;
	reg[1:0] size = 2'b10;
	reg sext = 0;
	reg [31:0] data, mem_addr = 0, pc_addr = 0;
	wire[31:0] mem_q, pc_q;

	ram_dual ram_test(.data(data), .we(we), .enable(enable), .mem_clk(clock), .size(size),
		.sext(sext), .pc_clk(clock), .real_clk(clock), .mem_addr(mem_addr), .pc_addr(pc_addr), .mem_q(mem_q), .pc_q(pc_q), .pc_override(0));
	
	initial begin 
		count = 0;
		clock = 0;
	end
	
	always begin
		#50
		count=count+ 1;
		//pc_addr = pc_addr + 4;
		pc_addr = pc_addr + 1;
	end
	
	always begin
		#25
		clock = clock + 1;
	end
	
	always @(count) begin
		case (count)
			0: begin enable = 1; we = 1; mem_addr = 4; data = 32'h12345678; size = 2; end
			1: begin mem_addr = 15; data = 32'h98768482; size = 1; end
			2: begin enable = 1; we = 0; end
			3: begin size = 0; end
			4: begin sext = 1; end
			5: begin size = 1; end
			6: begin size = 2; end
		endcase
	end
	
endmodule