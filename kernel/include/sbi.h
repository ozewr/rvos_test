#ifndef __SBI_H_
#define __SBI_H_
#include "types.h"
void puts(const char *s);
void cons_putc(int c);
void sbi_hsm_hart_star(uint64 hart_id);
void set_timer(uint64 stime_value);
#endif