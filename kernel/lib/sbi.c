#include "sbi.h"

uint64 SBI_SET_TIMER  = 0;
uint64 SBI_CONSOLE_GETCHAR = 2;
uint64 SBI_CONSOLE_PUTCHAR = 1;
uint64 SBI_EXT_HSM = 0x48534D;


uint64 sbi_call(uint64 sbi_typ,uint64 arg0,uint64 arg1,uint64 arg2,uint64 arg3) {
    uint64 ret_val;
    __asm__ volatile (
        "mv x17 , %[sbi_typ]\n"
        "mv x10 , %[arg0]\n"
        "mv x11 , %[arg1]\n"
        "mv x12 , %[arg2]\n"
        "mv x16 , %[arg3]\n"
        "ecall\n"
        "mv %[ret_val] , x10\n"
        : [ret_val] "=r" (ret_val)
        : [sbi_typ] "r" (sbi_typ),[arg0] "r" (arg0),[arg1] "r" (arg1) ,[arg2] "r" (arg2), [arg3] "r" (arg3)
        : "memory"
    );
    return ret_val;
}

void console_put_char(unsigned char ch){
    sbi_call(SBI_CONSOLE_PUTCHAR, ch,0, 0,0);
}

void set_timer(uint64 stime_value){
    sbi_call(SBI_SET_TIMER, stime_value, 0, 0,0);
}

void cons_putc(int c) {
    console_put_char((unsigned char)c);
}

void cputch(int c,int *cnt){
    cons_putc(c); 
    (*cnt)++;   
}

void puts(const char *s){
    int cnt = 0;
    char c;
    while((c = *s++) != '\0'){
        cputch(c, &cnt);        
    }
    cputch('\n', &cnt);
}



void 
sbi_hsm_hart_star(uint64 hart_id){
    //a0 hart_id
    //a1 start addr
    sbi_call(SBI_EXT_HSM, hart_id, 0x80200000, 64,0x0);
}
