# 32-bit processor
My final project! This is for ELEC2602 USYD (Verilog).

![alt text](https://private-user-images.githubusercontent.com/101756598/241557494-63ee856f-d4fb-47e1-9e92-3a49a2875b27.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJrZXkiOiJrZXkxIiwiZXhwIjoxNjg1Mjc0Mzk4LCJuYmYiOjE2ODUyNzQwOTgsInBhdGgiOiIvMTAxNzU2NTk4LzI0MTU1NzQ5NC02M2VlODU2Zi1kNGZiLTQ3ZTEtOWU5Mi0zYTQ5YTI4NzViMjcucG5nP1gtQW16LUFsZ29yaXRobT1BV1M0LUhNQUMtU0hBMjU2JlgtQW16LUNyZWRlbnRpYWw9QUtJQUlXTkpZQVg0Q1NWRUg1M0ElMkYyMDIzMDUyOCUyRnVzLWVhc3QtMSUyRnMzJTJGYXdzNF9yZXF1ZXN0JlgtQW16LURhdGU9MjAyMzA1MjhUMTE0MTM4WiZYLUFtei1FeHBpcmVzPTMwMCZYLUFtei1TaWduYXR1cmU9MGQ0YzM4MGVjNzYzMWJmZWYxZmVlNDU0MjZmNzVjOTVmZWQ3MjAzMDFmYTdiMTQ0ZGUxNzRiMWFlNTVjNzRhZSZYLUFtei1TaWduZWRIZWFkZXJzPWhvc3QifQ.di132nu4XvDO1FALDnb3uX_KyfNLV9lnmbde-O-VXx4)

<sub>*not pictured - various enable signals and clocks that control everything</sub>

It's a instruction-pipelined processor with RISC-V architecture (RV32I) consisting of the following stages:

1. Fetch instruction from memory
2. Do memory manipulation/jumping
3. Register write-back

![alt text](https://private-user-images.githubusercontent.com/101756598/241557502-84fb7ef6-8d2c-4f6f-a943-7e625bb03e44.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJrZXkiOiJrZXkxIiwiZXhwIjoxNjg1Mjc0Mzk4LCJuYmYiOjE2ODUyNzQwOTgsInBhdGgiOiIvMTAxNzU2NTk4LzI0MTU1NzUwMi04NGZiN2VmNi04ZDJjLTRmNmYtYTk0My03ZTYyNWJiMDNlNDQucG5nP1gtQW16LUFsZ29yaXRobT1BV1M0LUhNQUMtU0hBMjU2JlgtQW16LUNyZWRlbnRpYWw9QUtJQUlXTkpZQVg0Q1NWRUg1M0ElMkYyMDIzMDUyOCUyRnVzLWVhc3QtMSUyRnMzJTJGYXdzNF9yZXF1ZXN0JlgtQW16LURhdGU9MjAyMzA1MjhUMTE0MTM4WiZYLUFtei1FeHBpcmVzPTMwMCZYLUFtei1TaWduYXR1cmU9ZmE4OTRhODYxNDc5MmJjNDRmYmEyNTE5ZmNlZjNiMzY0YWQ2NzdhNzZhYjkxNzI5NTk5YmFiNTAzYmNlMDU1ZCZYLUFtei1TaWduZWRIZWFkZXJzPWhvc3QifQ.kQRv_zv7MMcy7Gn2Y9VGvHf-9AVXE53m-zWFoyEaaw0)

Stage 2 is triggered on the falling edge so that data dependencies don't happen. Jumping is also on stage 2 so that it only incurrs a 1-clock-cycle penalty (kinda shows on the FSM but not quite).

There is also a hidden stage (0) where the machine spends 512 cycles to reset the memory, so a nice little reset button!

I chose RISC-V because it is a load-store architecture so pipelining is a lot easier, but more importantly because I already had a toolchain setup before the project begun.

The top-level initialisation file `main_inst.v` is built for the [Altera DE1-SOC](http://de1-soc.terasic.com/).

## Example

The program below:
```
int volatile *const hex = (int *)0x0804;
int main() {
	int count = 0;
	while(1){
		*hex = count;
		asm volatile("nop");
		for (int i = 0; i < 3333333; i++){
			asm volatile("nop");
			asm volatile("nop");
			asm volatile("nop");
			asm volatile("nop");
			asm volatile("nop");
			asm volatile("nop");
			asm volatile("nop");
			asm volatile("nop");
			asm volatile("nop");
			asm volatile("nop");
			asm volatile("nop");
			asm volatile("nop");
		}
		count++;
	}
	return 0;
}
```
Compiles (`riscv64-unknown-elf-gcc -O1`, custom linker script) to
```
   0:   7ff00113                li      sp,2047
   4:   00c000ef                jal     ra,0x10
   8:   000017b7                lui     a5,0x1
   c:   80078623                sb      zero,-2036(a5) # 0x80c
  10:   00000713                li      a4,0
  14:   00001637                lui     a2,0x1
  18:   0032e6b7                lui     a3,0x32e
  1c:   0080006f                j       0x24
  20:   00170713                addi    a4,a4,1
  24:   80e62223                sw      a4,-2044(a2) # 0x804
  28:   00000013                nop
  2c:   cd568793                addi    a5,a3,-811 # 0x32dcd5
  30:   00000013                nop
  34:   00000013                nop
  38:   00000013                nop
  3c:   00000013                nop
  40:   00000013                nop
  44:   00000013                nop
  48:   00000013                nop
  4c:   00000013                nop
  50:   00000013                nop
  54:   00000013                nop
  58:   00000013                nop
  5c:   00000013                nop
  60:   fff78793                addi    a5,a5,-1
  64:   fc0796e3                bnez    a5,0x30
  68:   fb9ff06f                j       0x20
  6c:   0804                    addi    s1,sp,16
```
Instructions `0x30`-`0x64` take 14 + 1(jump penalty) = 15 clock cycles to execute. Repeating this 3,333,333 times gives 49,999,995 cycles spent within the for loop, The addition of `0x20`-`0x2c` and the jump at `0x68` adds 5 more cycles <sub>the branch penalty is still there, but it's been accounted for because `0x64` wouldn't jump at the last iteration</sub> to 50M. Thus if you have connected `hex_out` to your display of choice and your clock is 50Mhz you should see it increment precisely every second.

## What it has:
* Support for all basic operations in RV32I, including
    * arithmatic with register-register and register-immediate
    * memory load, store
    * branching, jumping, save PC
* Byte addressable memory to support different RISC-V load-store operations
* Some (virtual) memory-mapped IO:
    * writing to `0x0804` writes the data to `hex_out` 
    * writing to `0x0808` writes data to `led_out`
    * reading from `0x0816` blocks execution (literally stops the clock) until `num_clk` is "rising-edge triggered" (low on one clock edge, high on the next one)
    * writing to `0x080c` stops execution indefinitely until reset
    * other addresses can be freely added without much hassle
* A reset button (resets the output ports to default values)
* can run on 50Mhz clock

## What it does not have
* Communications, interrupts, CSR
* Support for extra memory
* Branch prediction

## How to run your program
1. Write code to compile to (optional if you just write assembly). If you do this step make sure to setup your stack space and end your program by writing to the halt address.
2. Compile and link such that
    * The executable is exactly 2048 bytes long (takes longer for RV32I to target memory bigger than this)
    * The first instruction starts at the beginning of the file

    Compilers automatically put alignment directives in. If you want you can remove them to make your code fit.
3. Load contents into ROM. This can be done in a variety of ways:
    * Convert binary to ASCII and link the result file in the `$readmemh` call in `inst_rom`
    * Make the rom such that it's targetable by the memory editor, and load the binary in while the FPGA is running
4. Upload, reset, see results
