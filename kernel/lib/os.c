#include "print.h"
#include "riscv.h"
#include "sbi.h"


int os_main(void){
    sbi_hsm_hart_star(1);
    const char *message = "hello rvos test!";
    const char *message2 = "print ok";
    print("%s \n%s\n",message,message2);
    // if(r_mhartid() == 0){
    //     print("%d \n cpu",1);
    // }
    while(1);
    return 0;
}
