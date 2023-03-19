#include "utils.h"
#include "riscv.h"
#include "types.h"

uint 
cpuid(){
    uint x;
    x = r_tp();
    return x;
}