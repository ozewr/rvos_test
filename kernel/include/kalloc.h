#ifndef __KALLOC_H_
#define __KALLOC_H_
#include "types.h"
#include "lock.h"
#include "utils.h"
#include "riscv.h"
#include "print.h"

void kfree(void *pa);
void freerange(void *pa_start, void *pa_end);
void kinit();
//void freerange(void *pa_start, void *pa_end);
#endif