#include "utils.h"
#include "riscv.h"
#include "types.h"

struct cpu cpus[NCPU];
uint 
cpuid(){
    uint x;
    x = r_tp();
    return x;
}

struct cpu *
getcpu(){
    struct cpu *r;
    int i = cpuid();
    r = &cpus[i];
    return r;
}

void
cpuinit(){
    int i = cpuid();
    cpus[i].id = i;
    cpus[i].intena = 0;
    cpus[i].noff = 0;
}