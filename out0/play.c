int volatile *const led = (int *)0x0808;
int volatile *const read_int = (int *)0x0816;

int main(){
	int data = 0x3fe;
	int idx = 0;
	while(1){
		*led = data;
		int res = *read_int;
		if (res == 0) idx--;
		else idx++;
		if (idx < 0) {idx = 9; data = 0x1ff;}
		else if (idx > 9) {idx = 0; data = 0x3fe;}
		else {
			if (res == 0) data = (data >> 1) | 0x200;
			else data = (data << 1) | 0x1;
		}
	}
	return 0;
}