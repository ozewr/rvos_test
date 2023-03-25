#include "trap.h"
#include "clock.h"
#include "lock.h"
#include "print.h"
#include "riscv.h"
#include "types.h"
#include "utils.h"


void kernelvec();
int get_dev();
void time_intr();
void break_intr();

extern uint64 ticks;
extern struct spinlock tickslock;

enum intr_cause{
    BREAKPOINT,
    TIME,
};

void trapinithart(){
    intr_on();
    w_sscratch(0);
    w_stvec((uint64)kernelvec);
    print("-- set kernel trap --\n");
}

void kerneltrap(){
    int which_dev = 0;
    uint64 sepc = r_sepc() ;
    uint64 sstatus = r_sstatus();
    uint64 scause = r_scause();
    uint64 sscratch = r_sscratch();
    
    //sepc = sepc +4;
    if((sstatus & SSTATUS_SPP) == 0){
        panic("trap not from kernel");
    }
    if(intr_get() != 0){
        panic("interrupt are enbale");
    }
    
    if((which_dev=get_dev()) == TIME){
        time_intr();
        return;
    }
    if(which_dev == BREAKPOINT){
        break_intr();
        return;
    }
    
    print("sepc : %p \nsstatus: %p \nscause %p :\nsscratch %d\n",sepc,sstatus,scause,sscratch);
    panic("not complie yet");
    
    //panic("trap seem ok?\n");
    //w_sepc(sepc+2);
}

int 
get_dev(){
    uint64 scause = r_scause();

    if(scause == 0x8000000000000005){
        return TIME;
    }
    if(scause == 0x0000000000000003){
        return BREAKPOINT;
    }
    return 0;

}

void time_intr(){
    acquire(&tickslock);
    if(ticks++ == 1000000){
        print("100ticks\n");
        ticks = 0;
    }
    release(&tickslock);
}

void break_intr(){
    uint64 sepc = r_sepc() ;
    uint64 sstatus = r_sstatus();
    uint64 scause = r_scause();
    uint64 sscratch = r_sscratch();
    
    print("sepc : %p \nsstatus: %p \nscause %p :\nsscratch %d\n",\
    sepc,sstatus,scause,sscratch);
    
    print("breakpoint by ebreak\n");
    
    w_sepc(sepc+2);
}
