#include "clock.h"
#include "riscv.h"
#include "lock.h"
#include "sbi.h"
#include "types.h"
#include "utils.h"

void clock_set_next_ent();
uint64 get_cycle();
struct spinlock tickslock;
uint64 ticks;
#define TIMEBASE 1000000

void timelockinit(){
    initlock(&tickslock, "time");
}


void timerinit(){
    // time interrupt on
    w_sie(SIE_STIE);
    
    ticks = 0;
    //for next time interrupt
    clock_set_next_ent();
}

void clock_set_next_ent(){
    //intr_on();
    set_timer(get_cycle()+TIMEBASE);
}

uint64 get_cycle(){
    return r_time();
}
