module eight_bit_ram(data, mem_addr, pc_addr, enable, we, mem_clk, pc_clk, mem_q, pc_q);
	parameter FILENAME = "C:/Users/gengr/Desktop/code/ELEC2602/project/empty.txt";
	parameter OFFSET = 0;

	input [7:0] data;
	input [31:0] mem_addr, pc_addr;
	input enable, we, mem_clk, pc_clk;
	output [7:0] mem_q, pc_q;
	
	reg[7:0] mem_qt = 0, pc_qt = 0;

	//raw ram, we have the four blocks
	reg [7:0] ram[512-1:0];
	
	wire[31:0] mem_tmp = mem_addr + OFFSET, pc_tmp = pc_addr + OFFSET;
	wire[29:0] mem_actual, pc_actual;
	assign mem_actual = mem_tmp[31:2];
	assign pc_actual = pc_tmp[31:2];
	
	initial begin
		$readmemh(FILENAME, ram);
	end
	
	always @ (posedge mem_clk) begin
		if (enable) begin
			if (we) begin //write
				ram[mem_actual] <= data[7:0];
			end else begin
				mem_qt <= ram[mem_actual];
			end
		end
	end
	
	always @ (posedge pc_clk) begin
		// Read 
		pc_qt <= ram[pc_actual];
	end

	
	assign mem_q = (mem_actual >= 512) ? 8'b0 : mem_qt;
	assign pc_q = (pc_actual >= 512) ? 8'b0 : pc_qt;
	

endmodule