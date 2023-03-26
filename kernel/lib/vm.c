#include "kalloc.h"
#include "print.h"
#include "riscv.h"
#include "types.h"
#include "vm.h"

pagetable_t kernel_pagetable;

extern char etext[];
extern char trampoline[];

pte_t* walk(pagetable_t pagetable ,uint64 va ,int alloc);
int mappages(pagetable_t pagetable, uint64 va,uint64 size,uint64 pa ,int perm);

void kvmmap(pagetable_t pagetable ,uint64 va,uint64 pa,uint64 size, int perm);



void
kvminit(void)
{
  kernel_pagetable = kvmmake();
}
void 
kvminitthart(){
    sfence_vma();
    w_satp(MAKE_SATP(kernel_pagetable));
    sfence_vma();
}

pagetable_t 
kvmmake(void){
    pagetable_t kpgtbl;
    kpgtbl = (pagetable_t) kalloc();
    memset(kpgtbl, 0, PGSIZE);
    kvmmap(kpgtbl,  KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    return kpgtbl;
}


void 
kvmmap(pagetable_t pagetable ,uint64 va,uint64 pa,uint64 size, int perm){
    if (mappages(pagetable, va, size, pa,perm) != 0) {
        panic("kvmap");
    }    
}
int 
mappages(pagetable_t pagetable, uint64 va,uint64 size,uint64 pa ,int perm){
    uint64 a,last;
    pte_t *pte;
    if(size == 0)
        panic("mappages:size");
    
    a = PGROUNDDOWN(va);
    last = PGROUNDDOWN(va+size -1);

    while(1){
        if((pte = walk(pagetable,a,1)) == 0){
            return -1;
        }
        if(*pte & PTE_V){
            panic("mappages:remap");
        }
        *pte = PA2PTE(pa) | perm | PTE_V;
        if(a == last){
            break;
        }
        a += PGSIZE;
        pa +=PGSIZE;
    }
    return 0;
}

pte_t* 
walk(pagetable_t pagetable ,uint64 va ,int alloc){
    int level = 0;
    if(va >= MAXVA)
        panic("walk :va to long");

    for(level = 2 ; level >0 ;level --){
        pte_t* pte = &pagetable[PX(level, va)];
        if(*pte & PTE_V){
            pagetable = (pagetable_t) PTE2PA(*pte);
        }else {
            if(!alloc || (pagetable =(pte_t *)kalloc()) == 0)
                return 0;
            memset(pagetable, 0, PGSIZE);
            *pte = PA2PTE(pagetable) | PTE_V;
        }
    }
    return &pagetable[PX(0,va)];
}