int volatile *const hex = (int *)0x0804;

int main() {
	int count = 0;
	
	while(1){
		*hex = count;
		//15 × 3333333 = 49,999,995
		//4 clock overhead for incrementing and writing, plus a "nop" is 50M
		asm volatile("nop");
		for (int i = 0; i < 3333333; i++){
			//12 nops, for loop takes 2, add branch pipeline (1) 
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
