#include "lock.h"
#include "riscv.h"
#include "utils.h"
#include "print.h"
int holding(struct spinlock *lk);


void 
initlock(struct spinlock *lk , char *name){
    lk->name = name ;
    lk->locked = 0;
    lk->cpu = 0;
}


void
push_off(void)
{
  int old = intr_get();

  intr_off();
  if(getcpu()->noff == 0)
    getcpu()->intena = old;
  getcpu()->noff += 1;
}

void
pop_off(void)
{
  struct cpu *c = getcpu();
  if(intr_get())
    panic("pop_off - interruptible");
  if(c->noff < 1)
    panic("pop_off");
  c->noff -= 1;
  if(c->noff == 0 && c->intena)
    intr_on();
}




void 
acquire(struct spinlock *lk){
    
    //intr_off();
    push_off();
    if(holding(lk))
        panic("holding lock");
    
    while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
        ;
    
    __sync_synchronize();    
    lk->cpu = getcpu();
    
}

void 
release(struct spinlock *lk){
    
    if(!holding(lk))
        panic("release");
    
    lk->cpu = 0;

    __sync_synchronize(); 
    
    __sync_lock_release(&lk->locked);
    
    pop_off();
}
int 
holding(struct spinlock *lk){
    int r;
    r = (lk->locked && lk->cpu == getcpu());
    return r;
}

