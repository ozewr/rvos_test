OUTPUT_ARCH(riscv) /* use riscv*/
ENTRY(_entry)      /* enter point*/

BASE_ADDRESS = 0X80200000; 

SECTIONS{
    . = BASE_ADDRESS;
    .text : {
        *(.text .text.*)
        . = ALIGN(0x1000);
        _trampoline = .;
        *(trampsec)
        . = ALIGN(0x1000);
        ASSERT(. - _trampoline == 0x1000, "error: trampoline larger than one page");
        PROVIDE(etext = .);
    }

    .rodata : {
        . = ALIGN(16);
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
        . = ALIGN(16);
        *(.bss)
        . = ALIGN(16);
        *(.bss.*)
        . = ALIGN(16);
        *(.sbss*)
    }

    PROVIDE(end = .);
    /DISCARD/ : {
        *(.eh_frame .note.GNU-stack)
    }
}
