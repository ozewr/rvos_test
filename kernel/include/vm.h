#ifndef _VM_H_
#define _VM_H_
#include "riscv.h"

void kvminit(void);
void kvminitthart();
pagetable_t kvmmake(void);

#endif