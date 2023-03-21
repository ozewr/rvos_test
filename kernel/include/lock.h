#ifndef __LOCK_H_
#define __LOCK_H_
#include "kernel/include/types.h"
struct spinlock {
    uint locked ;
    char *name ;
    struct cpu *cpu;
};




#endif