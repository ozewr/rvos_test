#ifndef __RISCV_H_
#define __RISCV_H_

#include "types.h"

#define SSTATUS_SPP (1L << 8)  // Previous mode, 1=Supervisor, 0=User
#define SSTATUS_SPIE (1L << 5) // Supervisor Previous Interrupt Enable
#define SSTATUS_UPIE (1L << 4) // User Previous Interrupt Enable
#define SSTATUS_SIE (1L << 1)  // Supervisor Interrupt Enable
#define SSTATUS_UIE (1L << 0)  // User Interrupt Enable

static inline uint64 
r_tp(){
    uint64 x;
    asm volatile(
        "mv %0 ,tp\n"
        :"=r" (x)
    );
    return x;
}

static inline uint64
r_sstatus(){
    uint64 x;
    asm volatile(
        "csrr %0 ,sstatus\n"
        :"=r"(x)
    );
    return x;
}

static inline void 
w_sstatus(uint64 x ){
    asm(
        "csrw sstatus , %0\n"
        :
        :"r"(x)
    );
}

static inline void
intr_on(){
    w_sstatus(r_sstatus() | SSTATUS_SIE);
}

static inline void
intr_off(){
    w_sstatus(r_sstatus() & ~SSTATUS_SIE);
}

static inline int
intr_get(){
    uint64 x = r_sstatus();
    return (x & SSTATUS_SIE) != 0;
}

#endif 