#ifndef __RISCV_H_
#define __RISCV_H_

#include "types.h"


static inline uint64 
r_tp(){
    uint64 x;
    asm volatile(
        "mv %0 ,tp\n"
        :"=r" (x)
    );
    return x;
}

#endif 