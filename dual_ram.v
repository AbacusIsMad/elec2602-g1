module dual_ram(data, we, enable, mem_clk, size, sext, pc_clk, mem_addr, 
	pc_addr, mem_q, pc_q, hex_out, led_out, num_in, num_clk, block, stop, real_clk);

	input[31:0] data;
	input we, enable, mem_clk, pc_clk, sext, real_clk;
	input[1:0] size;
	input[31:0] mem_addr, pc_addr;
	
	output reg[31:0] hex_out = 32'h80000000;
	output reg[9:0] led_out = 9'b000000000;
	input[7:0] num_in;
	input num_clk;
	
	output reg block = 0, stop = 0;
	
	output reg[31:0] mem_q, pc_q = 0;

	//reg[7:0] ram[2047:0];
	reg[31:0] ram[512:0];
	
	reg prev_num_clk = 0;
	always @(negedge real_clk) begin //reading block
		if (~prev_num_clk & num_clk) begin //pseudo rising edge. This goes first because of priority
			block <= 0;
		end else if (enable && ~we && (mem_addr == 32'h00000816)) begin //this sets block to true.
			block <= 1;
		end
		prev_num_clk <= num_clk; //store old value
	end
	
	
	
	
	reg[31:0] tmp = 0;
	//for loading, storing memory
	always @(posedge mem_clk) begin
		if (enable) begin
			//writing
			if (we) begin
				ram[mem_addr >> 2] <= data;
			end else begin //reading
				tmp <= mem_addr < 2048 ? ram[mem_addr >> 2] : 32'b0;
			end
		end
	end
	
	always @(tmp, size, mem_addr, num_in) begin
		if (mem_addr == 32'h00000816) begin
			mem_q = {24'h0, num_in[7:0]};
		end else begin
			case (size)
				2'b00: mem_q = {sext ? {24{tmp[7]}} : 24'h0, tmp[7:0]}; //byte
				2'b01: mem_q = {sext ? {16{tmp[15]}} : 16'h0, tmp[15:0]}; //hword
				default: mem_q = tmp[31:0]; //word
			endcase
		end
	end
	
	//for the pc
	always @(posedge pc_clk) begin
		pc_q <= pc_addr < 2048 ? ram[pc_addr >> 2] : 32'b0;
	end

endmodule

module dual_ramOLD(data, we, enable, mem_clk, size, sext, pc_clk, mem_addr, 
	pc_addr, mem_q, pc_q, hex_out, led_out, num_in, num_clk, block, stop, real_clk);

	input[31:0] data;
	input we, enable, mem_clk, pc_clk, sext, real_clk;
	input[1:0] size;
	input[31:0] mem_addr, pc_addr;
	
	output reg[31:0] hex_out = 32'h80000000;
	output reg[9:0] led_out = 9'b000000000;
	input[7:0] num_in;
	input num_clk;
	
	output reg block = 0, stop = 0;
	
	output reg[31:0] mem_q, pc_q = 0;

	//reg[7:0] ram[2047:0];
	reg[7:0] ram[63:0];
	
	initial begin
		$readmemh("C:/Users/gengr/Desktop/code/ELEC2602/project/printh.txt", ram);
	end
	
	reg prev_num_clk = 0;
	always @(negedge real_clk) begin //reading block
		if (~prev_num_clk & num_clk) begin //pseudo rising edge. This goes first because of priority
			block <= 0;
		end else if (enable && ~we && (mem_addr == 32'h00000816)) begin //this sets block to true.
			block <= 1;
		end
		prev_num_clk <= num_clk; //store old value
	end
	
	
	
	
	reg[31:0] tmp = 0;
	//for loading, storing memory
	always @(posedge mem_clk) begin
		if (enable) begin
			//writing
			if (we) begin
				if (mem_addr == 32'h00000804) begin //hex
					hex_out <= data;
				end else if (mem_addr == 32'h00000808) begin //led
					led_out <= data[9:0];
				end else if (mem_addr == 32'h0000080c) begin //halt
					stop <= 1;
				end else begin //write to out of bounds results in no operation, so everything is pretty good
					ram[mem_addr] <= data[7:0];
					if (size[1] | size[0]) ram[mem_addr+1] <= data[15:8];
					if (size[1]) begin
						ram[mem_addr+2] <= data[23:16];
						ram[mem_addr+3] <= data[31:24];
					end
				end
			end else begin //reading
				tmp[7:0] <= mem_addr < 2048 ? ram[mem_addr] : 8'b0;
				tmp[15:8] <= mem_addr + 1 < 2048 ? ram[mem_addr + 1] : 8'b0;
				tmp[23:16] <= mem_addr + 2 < 2048 ? ram[mem_addr + 2] : 8'b0;
				tmp[31:24] <= mem_addr + 3 < 2048 ? ram[mem_addr + 3] : 8'b0;
			end
		end
	end
	
	always @(tmp, size, mem_addr, num_in) begin
		if (mem_addr == 32'h00000816) begin
			mem_q = {24'h0, num_in[7:0]};
		end else begin
			case (size)
				2'b00: mem_q = {sext ? {24{tmp[7]}} : 24'h0, tmp[7:0]}; //byte
				2'b01: mem_q = {sext ? {16{tmp[15]}} : 16'h0, tmp[15:0]}; //hword
				default: mem_q = tmp[31:0]; //word
			endcase
		end
	end
	
	//for the pc
	always @(posedge pc_clk) begin
		pc_q[7:0] <= pc_addr < 2048 ? ram[pc_addr] : 8'b0;
		pc_q[15:8] <= pc_addr + 1 < 2048 ? ram[pc_addr + 1] : 8'b0;
		pc_q[23:16] <= pc_addr + 2 < 2048 ? ram[pc_addr + 2] : 8'b0;
		pc_q[31:24] <= pc_addr + 3 < 2048 ? ram[pc_addr + 3] : 8'b0;
	end

endmodule