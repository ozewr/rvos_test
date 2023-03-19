#include "types.h"
#include "utils.h"
#include "sbi.h"

#define NCPU 3
__attribute__((aligned(16))) char stacks[4096 * NCPU];

void thread_start();
extern void os_main();

void 
start(){
    thread_start();
    os_main();
}

void 
thread_start(){
    uint id = cpuid();
    int i;
    for(i = 0;i < NCPU ;i++){
        if(i != id)
            sbi_hsm_hart_star(i);
    }
}