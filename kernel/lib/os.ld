OUTPUT_ARCH(riscv) /* use riscv*/
ENTRY(_entry)      /* enter point*/

BASE_ADDRESS = 0X80200000; 

SECTIONS{
    . = BASE_ADDRESS;
    .text : {
        *(.text._entry)
        *(.text .stub .text.* .gnu.linkonce.t.*)   
    }
    PROVIDE(etext = .);
    .rodata : {
        *(.rodata .rodata.* .gnu.linkonce.r.*)
    }

    . = ALIGN(0x1000);



    .data : {
        . = ALIGN(16);
        *(.sdata .sdata.*)
        . = ALIGN(16);
        *(.data .data.*)       
    }

    .bss : {
        *(.bss)
        *(.bss.*)
        *(.sbss*)
    }

    PROVIDE(end = .);
    /DISCARD/ : {
        *(.eh_frame .note.GNU-stack)
    }
}
