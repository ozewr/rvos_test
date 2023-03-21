#include "types.h"
#include "utils.h"
#include "sbi.h"
#include "print.h"
__attribute__((aligned(16))) char stacks[4096 * NCPU];



void thread_start();
extern void os_main();



void 
start(){
    thread_start();
    if(cpuid() == 0){
        printinit();
    }
    cpuinit();
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