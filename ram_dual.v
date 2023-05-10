module ram_dual(data, we, enable, mem_clk, size, sext, pc_clk, mem_addr, 
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
	//output [31:0] mem_q, pc_q;

	//input blocking logic
	reg prev_num_clk = 0;
	always @(negedge real_clk) begin //reading block
		if (~prev_num_clk & num_clk) begin //pseudo rising edge. This goes first because of priority
			block <= 0;
		end else if (enable && ~we && (mem_addr == 32'h00000816)) begin //this sets block to true.
			block <= 1;
		end
		prev_num_clk <= num_clk; //store old value
	end
	
	//the actual blocks
	wire[31:0] mem_tmp, pc_tmp;
	reg[4:0] s_enable;
	reg[31:0] mem_in; //this is used for reorganising the data before putting it in
	//r1 is aligned to the 4 byte boundary, r2 is offeset by 1, and so on.
	eight_bit_ram#(.FILENAME("C:/Users/14133/Documents/GitHub/elec2602-g1/out/add_2_numbers1.txt"), .OFFSET(3))
		r1(.data(mem_in[7:0]), .mem_addr(mem_addr), .pc_addr(pc_addr),
		.enable(enable), .we(we & s_enable[0]),
		.mem_clk(mem_clk), .pc_clk(pc_clk), .mem_q(mem_tmp[7:0]), .pc_q(pc_tmp[7:0]));
	eight_bit_ram#(.FILENAME("C:/Users/14133/Documents/GitHub/elec2602-g1/out/add_2_numbers2.txt"), .OFFSET(2))
		r2(.data(mem_in[15:8]), .mem_addr(mem_addr), .pc_addr(pc_addr),
		.enable(enable), .we(we & s_enable[1]),
		.mem_clk(mem_clk), .pc_clk(pc_clk), .mem_q(mem_tmp[15:8]), .pc_q(pc_tmp[15:8]));
	eight_bit_ram#(.FILENAME("C:/Users/14133/Documents/GitHub/elec2602-g1/out/add_2_numbers3.txt"), .OFFSET(1))
		r3(.data(mem_in[23:16]), .mem_addr(mem_addr), .pc_addr(pc_addr),
		.enable(enable), .we(we & s_enable[2]),
		.mem_clk(mem_clk), .pc_clk(pc_clk), .mem_q(mem_tmp[23:16]), .pc_q(pc_tmp[23:16]));
	eight_bit_ram#(.FILENAME("C:/Users/14133/Documents/GitHub/elec2602-g1/out/add_2_numbers4.txt"), .OFFSET(0))
		r4(.data(mem_in[31:24]), .mem_addr(mem_addr), .pc_addr(pc_addr),
		.enable(enable), .we(we & s_enable[3]),
		.mem_clk(mem_clk), .pc_clk(pc_clk), .mem_q(mem_tmp[31:24]), .pc_q(pc_tmp[31:24]));
	
	//output ports
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
				end
			end
		end
	end
	

	//this generates which bytes to write, as well as how to order the result data.
	reg[31:0] mem_ordered;
	always @(mem_addr[1:0], size, mem_tmp) begin
		case ({mem_addr[1:0], size})
			//address aligned, then offset 1, then 2, then 3
			default: begin s_enable = 4'b0001; end
			4'b0001: begin s_enable = 4'b0011; end
			4'b0010: begin s_enable = 4'b1111; end
			
			4'b0100: begin s_enable = 4'b0010; end
			4'b0101: begin s_enable = 4'b0110; end
			4'b0110: begin s_enable = 4'b1111; end
			
			4'b1000: begin s_enable = 4'b0100; end
			4'b1001: begin s_enable = 4'b1100; end
			4'b1010: begin s_enable = 4'b1111; end
			
			4'b1100: begin s_enable = 4'b1000; end
			4'b1101: begin s_enable = 4'b1001; end
			4'b1110: begin s_enable = 4'b1111; end
		endcase
	end
	
	
	//similiar lut here too, this is for mem_ordered and mem_in
	wire [31:0] in0 = data, in1 = {data[23:0], data[31:24]}, in2 = {data[15:0], data[31:16]}, in3 = {data[7:0], data[31:8]};
	wire [31:0] ou0 = mem_tmp, ou1 = {mem_tmp[7:0], mem_tmp[31:8]}, ou2 = {mem_tmp[15:0], mem_tmp[31:16]}, ou3 = {mem_tmp[23:0], mem_tmp[31:24]};
	
	always @(mem_addr[1:0]) begin
		case (mem_addr[1:0])
			2'b00: begin mem_ordered = ou0; mem_in = in0; end
			2'b01: begin mem_ordered = ou1; mem_in = in1; end
			2'b10: begin mem_ordered = ou2; mem_in = in2; end
			2'b11: begin mem_ordered = ou3; mem_in = in3; end
		endcase
	end
	
	
	
	always @(pc_addr[1:0], pc_tmp) begin
		case(pc_addr[1:0])
			2'b00: pc_q = pc_tmp; 
			2'b01: pc_q = {pc_tmp[7:0], pc_tmp[31:8]}; 
			2'b10: pc_q = {pc_tmp[15:0], pc_tmp[31:16]}; 
			2'b11: pc_q = {pc_tmp[23:0], pc_tmp[31:24]}; 
		endcase
	end
	
	always @(size, sext, mem_addr, mem_ordered, num_in) begin
		if (mem_addr == 32'h00000816) begin
			mem_q = {24'h0, num_in[7:0]};
		end else begin
			case (size)
				2'b00: mem_q = {sext ? {24{mem_ordered[7]}} : 24'h0, mem_ordered[7:0]}; //byte
				2'b01: mem_q = {sext ? {16{mem_ordered[15]}} : 16'h0, mem_ordered[15:0]}; //hword
				default: mem_q = mem_ordered[31:0]; //word
			endcase
		end
	end
	
	
endmodule
