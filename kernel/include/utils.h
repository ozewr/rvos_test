#ifndef _UTILS_H_
#define _UTILS_H_
#include "riscv.h"
#include "types.h"
#include "lock.h"
#include "string.h"
#include "vm.h"
#define NCPU 3
struct context {

};
struct cpu {
    int id;
    int noff;
    int intena;
};


void cpuinit();
struct cpu * getcpu();
//lock.h
void initlock(struct spinlock *lk , char *name);
void acquire(struct spinlock *lk);
void release(struct spinlock *lk);



uint cpuid();
#endif