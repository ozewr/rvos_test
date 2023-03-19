
kernel/lib/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080200000 <_entry>:
.section .text
.global _entry

_entry:
    la sp,stacks
    80200000:	00001117          	auipc	sp,0x1
    80200004:	02013103          	ld	sp,32(sp) # 80201020 <_GLOBAL_OFFSET_TABLE_+0x8>
    li t0,1024*4
    80200008:	6285                	lui	t0,0x1
    add tp,a0,x0
    8020000a:	00050233          	add	tp,a0,zero
    addi a0,a0,1
    8020000e:	0505                	addi	a0,a0,1
    mul a0,a0,t0
    80200010:	02550533          	mul	a0,a0,t0
    add sp,sp,a0
    80200014:	912a                	add	sp,sp,a0
    #la sp, bootstacktop 
    call start
    80200016:	00000097          	auipc	ra,0x0
    8020001a:	43c080e7          	jalr	1084(ra) # 80200452 <start>

000000008020001e <os_main>:
#include "print.h"
#include "riscv.h"
#include "sbi.h"


int os_main(void){
    8020001e:	1141                	addi	sp,sp,-16
    80200020:	e406                	sd	ra,8(sp)
    80200022:	e022                	sd	s0,0(sp)
    80200024:	0800                	addi	s0,sp,16
    sbi_hsm_hart_star(1);
    80200026:	4505                	li	a0,1
    80200028:	00000097          	auipc	ra,0x0
    8020002c:	124080e7          	jalr	292(ra) # 8020014c <sbi_hsm_hart_star>
    const char *message = "hello rvos test!";
    const char *message2 = "print ok";
    print("%s \n%s\n",message,message2);
    80200030:	00000617          	auipc	a2,0x0
    80200034:	45860613          	addi	a2,a2,1112 # 80200488 <cpuid+0x16>
    80200038:	00000597          	auipc	a1,0x0
    8020003c:	46058593          	addi	a1,a1,1120 # 80200498 <cpuid+0x26>
    80200040:	00000517          	auipc	a0,0x0
    80200044:	47050513          	addi	a0,a0,1136 # 802004b0 <cpuid+0x3e>
    80200048:	00000097          	auipc	ra,0x0
    8020004c:	216080e7          	jalr	534(ra) # 8020025e <print>
    // if(r_mhartid() == 0){
    //     print("%d \n cpu",1);
    // }
    while(1);
    80200050:	a001                	j	80200050 <os_main+0x32>

0000000080200052 <sbi_call>:
uint64 SBI_CONSOLE_GETCHAR = 2;
uint64 SBI_CONSOLE_PUTCHAR = 1;
uint64 SBI_EXT_HSM = 0x48534D;


uint64 sbi_call(uint64 sbi_typ,uint64 arg0,uint64 arg1,uint64 arg2,uint64 arg3) {
    80200052:	1141                	addi	sp,sp,-16
    80200054:	e422                	sd	s0,8(sp)
    80200056:	0800                	addi	s0,sp,16
    uint64 ret_val;
    __asm__ volatile (
    80200058:	88aa                	mv	a7,a0
    8020005a:	852e                	mv	a0,a1
    8020005c:	85b2                	mv	a1,a2
    8020005e:	8636                	mv	a2,a3
    80200060:	883a                	mv	a6,a4
    80200062:	00000073          	ecall
    80200066:	852a                	mv	a0,a0
        : [ret_val] "=r" (ret_val)
        : [sbi_typ] "r" (sbi_typ),[arg0] "r" (arg0),[arg1] "r" (arg1) ,[arg2] "r" (arg2), [arg3] "r" (arg3)
        : "memory"
    );
    return ret_val;
}
    80200068:	6422                	ld	s0,8(sp)
    8020006a:	0141                	addi	sp,sp,16
    8020006c:	8082                	ret

000000008020006e <console_put_char>:

void console_put_char(unsigned char ch){
    8020006e:	1141                	addi	sp,sp,-16
    80200070:	e406                	sd	ra,8(sp)
    80200072:	e022                	sd	s0,0(sp)
    80200074:	0800                	addi	s0,sp,16
    80200076:	85aa                	mv	a1,a0
    sbi_call(SBI_CONSOLE_PUTCHAR, ch,0, 0,0);
    80200078:	4701                	li	a4,0
    8020007a:	4681                	li	a3,0
    8020007c:	4601                	li	a2,0
    8020007e:	00001517          	auipc	a0,0x1
    80200082:	f8253503          	ld	a0,-126(a0) # 80201000 <SBI_CONSOLE_PUTCHAR>
    80200086:	00000097          	auipc	ra,0x0
    8020008a:	fcc080e7          	jalr	-52(ra) # 80200052 <sbi_call>
}
    8020008e:	60a2                	ld	ra,8(sp)
    80200090:	6402                	ld	s0,0(sp)
    80200092:	0141                	addi	sp,sp,16
    80200094:	8082                	ret

0000000080200096 <set_timer>:

void set_timer(uint64 stime_value){
    80200096:	1141                	addi	sp,sp,-16
    80200098:	e406                	sd	ra,8(sp)
    8020009a:	e022                	sd	s0,0(sp)
    8020009c:	0800                	addi	s0,sp,16
    8020009e:	85aa                	mv	a1,a0
    sbi_call(SBI_SET_TIMER, stime_value, 0, 0,0);
    802000a0:	4701                	li	a4,0
    802000a2:	4681                	li	a3,0
    802000a4:	4601                	li	a2,0
    802000a6:	00001517          	auipc	a0,0x1
    802000aa:	f9a53503          	ld	a0,-102(a0) # 80201040 <SBI_SET_TIMER>
    802000ae:	00000097          	auipc	ra,0x0
    802000b2:	fa4080e7          	jalr	-92(ra) # 80200052 <sbi_call>
}
    802000b6:	60a2                	ld	ra,8(sp)
    802000b8:	6402                	ld	s0,0(sp)
    802000ba:	0141                	addi	sp,sp,16
    802000bc:	8082                	ret

00000000802000be <cons_putc>:

void cons_putc(int c) {
    802000be:	1141                	addi	sp,sp,-16
    802000c0:	e406                	sd	ra,8(sp)
    802000c2:	e022                	sd	s0,0(sp)
    802000c4:	0800                	addi	s0,sp,16
    console_put_char((unsigned char)c);
    802000c6:	0ff57513          	zext.b	a0,a0
    802000ca:	00000097          	auipc	ra,0x0
    802000ce:	fa4080e7          	jalr	-92(ra) # 8020006e <console_put_char>
}
    802000d2:	60a2                	ld	ra,8(sp)
    802000d4:	6402                	ld	s0,0(sp)
    802000d6:	0141                	addi	sp,sp,16
    802000d8:	8082                	ret

00000000802000da <cputch>:

void cputch(int c,int *cnt){
    802000da:	1101                	addi	sp,sp,-32
    802000dc:	ec06                	sd	ra,24(sp)
    802000de:	e822                	sd	s0,16(sp)
    802000e0:	e426                	sd	s1,8(sp)
    802000e2:	1000                	addi	s0,sp,32
    802000e4:	84ae                	mv	s1,a1
    console_put_char((unsigned char)c);
    802000e6:	0ff57513          	zext.b	a0,a0
    802000ea:	00000097          	auipc	ra,0x0
    802000ee:	f84080e7          	jalr	-124(ra) # 8020006e <console_put_char>
    cons_putc(c); 
    (*cnt)++;   
    802000f2:	409c                	lw	a5,0(s1)
    802000f4:	2785                	addiw	a5,a5,1
    802000f6:	c09c                	sw	a5,0(s1)
}
    802000f8:	60e2                	ld	ra,24(sp)
    802000fa:	6442                	ld	s0,16(sp)
    802000fc:	64a2                	ld	s1,8(sp)
    802000fe:	6105                	addi	sp,sp,32
    80200100:	8082                	ret

0000000080200102 <puts>:

void puts(const char *s){
    80200102:	7179                	addi	sp,sp,-48
    80200104:	f406                	sd	ra,40(sp)
    80200106:	f022                	sd	s0,32(sp)
    80200108:	ec26                	sd	s1,24(sp)
    8020010a:	e84a                	sd	s2,16(sp)
    8020010c:	1800                	addi	s0,sp,48
    int cnt = 0;
    8020010e:	fc042e23          	sw	zero,-36(s0)
    char c;
    while((c = *s++) != '\0'){
    80200112:	00150493          	addi	s1,a0,1
    80200116:	00054503          	lbu	a0,0(a0)
    8020011a:	cd01                	beqz	a0,80200132 <puts+0x30>
        cputch(c, &cnt);        
    8020011c:	fdc40913          	addi	s2,s0,-36
    80200120:	85ca                	mv	a1,s2
    80200122:	00000097          	auipc	ra,0x0
    80200126:	fb8080e7          	jalr	-72(ra) # 802000da <cputch>
    while((c = *s++) != '\0'){
    8020012a:	0485                	addi	s1,s1,1
    8020012c:	fff4c503          	lbu	a0,-1(s1)
    80200130:	f965                	bnez	a0,80200120 <puts+0x1e>
    }
    cputch('\n', &cnt);
    80200132:	fdc40593          	addi	a1,s0,-36
    80200136:	4529                	li	a0,10
    80200138:	00000097          	auipc	ra,0x0
    8020013c:	fa2080e7          	jalr	-94(ra) # 802000da <cputch>
}
    80200140:	70a2                	ld	ra,40(sp)
    80200142:	7402                	ld	s0,32(sp)
    80200144:	64e2                	ld	s1,24(sp)
    80200146:	6942                	ld	s2,16(sp)
    80200148:	6145                	addi	sp,sp,48
    8020014a:	8082                	ret

000000008020014c <sbi_hsm_hart_star>:



void 
sbi_hsm_hart_star(uint64 hart_id){
    8020014c:	1141                	addi	sp,sp,-16
    8020014e:	e406                	sd	ra,8(sp)
    80200150:	e022                	sd	s0,0(sp)
    80200152:	0800                	addi	s0,sp,16
    80200154:	85aa                	mv	a1,a0
    //a0 hart_id
    //a1 start addr
    sbi_call(SBI_EXT_HSM, hart_id, 0x80200000, 64,0x0);
    80200156:	4701                	li	a4,0
    80200158:	04000693          	li	a3,64
    8020015c:	40100613          	li	a2,1025
    80200160:	0656                	slli	a2,a2,0x15
    80200162:	00001517          	auipc	a0,0x1
    80200166:	ea653503          	ld	a0,-346(a0) # 80201008 <SBI_EXT_HSM>
    8020016a:	00000097          	auipc	ra,0x0
    8020016e:	ee8080e7          	jalr	-280(ra) # 80200052 <sbi_call>
}
    80200172:	60a2                	ld	ra,8(sp)
    80200174:	6402                	ld	s0,0(sp)
    80200176:	0141                	addi	sp,sp,16
    80200178:	8082                	ret

000000008020017a <printint>:
void panic(char *s);


static void
printint(int xx, int base, int sign)
{
    8020017a:	7179                	addi	sp,sp,-48
    8020017c:	f406                	sd	ra,40(sp)
    8020017e:	f022                	sd	s0,32(sp)
    80200180:	ec26                	sd	s1,24(sp)
    80200182:	e84a                	sd	s2,16(sp)
    80200184:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80200186:	c219                	beqz	a2,8020018c <printint+0x12>
    80200188:	08054663          	bltz	a0,80200214 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    8020018c:	2501                	sext.w	a0,a0
    8020018e:	4881                	li	a7,0

  i = 0;
    80200190:	fd040913          	addi	s2,s0,-48
    x = xx;
    80200194:	86ca                	mv	a3,s2
  i = 0;
    80200196:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80200198:	2581                	sext.w	a1,a1
    8020019a:	00000617          	auipc	a2,0x0
    8020019e:	34660613          	addi	a2,a2,838 # 802004e0 <digits>
    802001a2:	883a                	mv	a6,a4
    802001a4:	2705                	addiw	a4,a4,1
    802001a6:	02b577bb          	remuw	a5,a0,a1
    802001aa:	1782                	slli	a5,a5,0x20
    802001ac:	9381                	srli	a5,a5,0x20
    802001ae:	97b2                	add	a5,a5,a2
    802001b0:	0007c783          	lbu	a5,0(a5)
    802001b4:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    802001b8:	0005079b          	sext.w	a5,a0
    802001bc:	02b5553b          	divuw	a0,a0,a1
    802001c0:	0685                	addi	a3,a3,1
    802001c2:	feb7f0e3          	bgeu	a5,a1,802001a2 <printint+0x28>

  if(sign)
    802001c6:	00088c63          	beqz	a7,802001de <printint+0x64>
    buf[i++] = '-';
    802001ca:	fe070793          	addi	a5,a4,-32
    802001ce:	00878733          	add	a4,a5,s0
    802001d2:	02d00793          	li	a5,45
    802001d6:	fef70823          	sb	a5,-16(a4)
    802001da:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    802001de:	02e05563          	blez	a4,80200208 <printint+0x8e>
    802001e2:	fd040493          	addi	s1,s0,-48
    802001e6:	94ba                	add	s1,s1,a4
    802001e8:	197d                	addi	s2,s2,-1
    802001ea:	993a                	add	s2,s2,a4
    802001ec:	377d                	addiw	a4,a4,-1
    802001ee:	1702                	slli	a4,a4,0x20
    802001f0:	9301                	srli	a4,a4,0x20
    802001f2:	40e90933          	sub	s2,s2,a4
    cons_putc(buf[i]);
    802001f6:	fff4c503          	lbu	a0,-1(s1)
    802001fa:	00000097          	auipc	ra,0x0
    802001fe:	ec4080e7          	jalr	-316(ra) # 802000be <cons_putc>
  while(--i >= 0)
    80200202:	14fd                	addi	s1,s1,-1
    80200204:	ff2499e3          	bne	s1,s2,802001f6 <printint+0x7c>
}
    80200208:	70a2                	ld	ra,40(sp)
    8020020a:	7402                	ld	s0,32(sp)
    8020020c:	64e2                	ld	s1,24(sp)
    8020020e:	6942                	ld	s2,16(sp)
    80200210:	6145                	addi	sp,sp,48
    80200212:	8082                	ret
    x = -xx;
    80200214:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80200218:	4885                	li	a7,1
    x = -xx;
    8020021a:	bf9d                	j	80200190 <printint+0x16>

000000008020021c <panic>:

}

void
panic(char *s)
{
    8020021c:	1101                	addi	sp,sp,-32
    8020021e:	ec06                	sd	ra,24(sp)
    80200220:	e822                	sd	s0,16(sp)
    80200222:	e426                	sd	s1,8(sp)
    80200224:	1000                	addi	s0,sp,32
    80200226:	84aa                	mv	s1,a0
  print("panic: ");
    80200228:	00000517          	auipc	a0,0x0
    8020022c:	29050513          	addi	a0,a0,656 # 802004b8 <cpuid+0x46>
    80200230:	00000097          	auipc	ra,0x0
    80200234:	02e080e7          	jalr	46(ra) # 8020025e <print>
  print(s);
    80200238:	8526                	mv	a0,s1
    8020023a:	00000097          	auipc	ra,0x0
    8020023e:	024080e7          	jalr	36(ra) # 8020025e <print>
  print("\n");
    80200242:	00000517          	auipc	a0,0x0
    80200246:	27e50513          	addi	a0,a0,638 # 802004c0 <cpuid+0x4e>
    8020024a:	00000097          	auipc	ra,0x0
    8020024e:	014080e7          	jalr	20(ra) # 8020025e <print>
  panicked = 1; // freeze uart output from other CPUs
    80200252:	4785                	li	a5,1
    80200254:	00001717          	auipc	a4,0x1
    80200258:	def72a23          	sw	a5,-524(a4) # 80201048 <panicked>
  for(;;)
    8020025c:	a001                	j	8020025c <panic+0x40>

000000008020025e <print>:
{
    8020025e:	7171                	addi	sp,sp,-176
    80200260:	f486                	sd	ra,104(sp)
    80200262:	f0a2                	sd	s0,96(sp)
    80200264:	eca6                	sd	s1,88(sp)
    80200266:	e8ca                	sd	s2,80(sp)
    80200268:	e4ce                	sd	s3,72(sp)
    8020026a:	e0d2                	sd	s4,64(sp)
    8020026c:	fc56                	sd	s5,56(sp)
    8020026e:	f85a                	sd	s6,48(sp)
    80200270:	f45e                	sd	s7,40(sp)
    80200272:	f062                	sd	s8,32(sp)
    80200274:	ec66                	sd	s9,24(sp)
    80200276:	e86a                	sd	s10,16(sp)
    80200278:	1880                	addi	s0,sp,112
    8020027a:	e40c                	sd	a1,8(s0)
    8020027c:	e810                	sd	a2,16(s0)
    8020027e:	ec14                	sd	a3,24(s0)
    80200280:	f018                	sd	a4,32(s0)
    80200282:	f41c                	sd	a5,40(s0)
    80200284:	03043823          	sd	a6,48(s0)
    80200288:	03143c23          	sd	a7,56(s0)
  if (fmt == 0)
    8020028c:	c90d                	beqz	a0,802002be <print+0x60>
    8020028e:	8a2a                	mv	s4,a0
  va_start(ap, fmt);
    80200290:	00840793          	addi	a5,s0,8
    80200294:	f8f43c23          	sd	a5,-104(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80200298:	00054503          	lbu	a0,0(a0)
    8020029c:	14050663          	beqz	a0,802003e8 <print+0x18a>
    802002a0:	4981                	li	s3,0
    if(c != '%'){
    802002a2:	02500a93          	li	s5,37
    switch(c){
    802002a6:	07000b93          	li	s7,112
  cons_putc('x');
    802002aa:	4d41                	li	s10,16
    cons_putc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    802002ac:	00000b17          	auipc	s6,0x0
    802002b0:	234b0b13          	addi	s6,s6,564 # 802004e0 <digits>
    switch(c){
    802002b4:	07300c93          	li	s9,115
    802002b8:	06400c13          	li	s8,100
    802002bc:	a025                	j	802002e4 <print+0x86>
    panic("null fmt");
    802002be:	00000517          	auipc	a0,0x0
    802002c2:	21250513          	addi	a0,a0,530 # 802004d0 <cpuid+0x5e>
    802002c6:	00000097          	auipc	ra,0x0
    802002ca:	f56080e7          	jalr	-170(ra) # 8020021c <panic>
      cons_putc(c);
    802002ce:	00000097          	auipc	ra,0x0
    802002d2:	df0080e7          	jalr	-528(ra) # 802000be <cons_putc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    802002d6:	2985                	addiw	s3,s3,1
    802002d8:	013a07b3          	add	a5,s4,s3
    802002dc:	0007c503          	lbu	a0,0(a5)
    802002e0:	10050463          	beqz	a0,802003e8 <print+0x18a>
    if(c != '%'){
    802002e4:	ff5515e3          	bne	a0,s5,802002ce <print+0x70>
    c = fmt[++i] & 0xff;
    802002e8:	2985                	addiw	s3,s3,1
    802002ea:	013a07b3          	add	a5,s4,s3
    802002ee:	0007c783          	lbu	a5,0(a5)
    802002f2:	0007849b          	sext.w	s1,a5
    if(c == 0)
    802002f6:	cbed                	beqz	a5,802003e8 <print+0x18a>
    switch(c){
    802002f8:	05778a63          	beq	a5,s7,8020034c <print+0xee>
    802002fc:	02fbf663          	bgeu	s7,a5,80200328 <print+0xca>
    80200300:	09978863          	beq	a5,s9,80200390 <print+0x132>
    80200304:	07800713          	li	a4,120
    80200308:	0ce79563          	bne	a5,a4,802003d2 <print+0x174>
      printint(va_arg(ap, int), 16, 1);
    8020030c:	f9843783          	ld	a5,-104(s0)
    80200310:	00878713          	addi	a4,a5,8
    80200314:	f8e43c23          	sd	a4,-104(s0)
    80200318:	4605                	li	a2,1
    8020031a:	85ea                	mv	a1,s10
    8020031c:	4388                	lw	a0,0(a5)
    8020031e:	00000097          	auipc	ra,0x0
    80200322:	e5c080e7          	jalr	-420(ra) # 8020017a <printint>
      break;
    80200326:	bf45                	j	802002d6 <print+0x78>
    switch(c){
    80200328:	09578f63          	beq	a5,s5,802003c6 <print+0x168>
    8020032c:	0b879363          	bne	a5,s8,802003d2 <print+0x174>
      printint(va_arg(ap, int), 10, 1);
    80200330:	f9843783          	ld	a5,-104(s0)
    80200334:	00878713          	addi	a4,a5,8
    80200338:	f8e43c23          	sd	a4,-104(s0)
    8020033c:	4605                	li	a2,1
    8020033e:	45a9                	li	a1,10
    80200340:	4388                	lw	a0,0(a5)
    80200342:	00000097          	auipc	ra,0x0
    80200346:	e38080e7          	jalr	-456(ra) # 8020017a <printint>
      break;
    8020034a:	b771                	j	802002d6 <print+0x78>
      printptr(va_arg(ap, uint64));
    8020034c:	f9843783          	ld	a5,-104(s0)
    80200350:	00878713          	addi	a4,a5,8
    80200354:	f8e43c23          	sd	a4,-104(s0)
    80200358:	0007b903          	ld	s2,0(a5)
  cons_putc('0');
    8020035c:	03000513          	li	a0,48
    80200360:	00000097          	auipc	ra,0x0
    80200364:	d5e080e7          	jalr	-674(ra) # 802000be <cons_putc>
  cons_putc('x');
    80200368:	07800513          	li	a0,120
    8020036c:	00000097          	auipc	ra,0x0
    80200370:	d52080e7          	jalr	-686(ra) # 802000be <cons_putc>
    80200374:	84ea                	mv	s1,s10
    cons_putc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80200376:	03c95793          	srli	a5,s2,0x3c
    8020037a:	97da                	add	a5,a5,s6
    8020037c:	0007c503          	lbu	a0,0(a5)
    80200380:	00000097          	auipc	ra,0x0
    80200384:	d3e080e7          	jalr	-706(ra) # 802000be <cons_putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80200388:	0912                	slli	s2,s2,0x4
    8020038a:	34fd                	addiw	s1,s1,-1
    8020038c:	f4ed                	bnez	s1,80200376 <print+0x118>
    8020038e:	b7a1                	j	802002d6 <print+0x78>
      if((s = va_arg(ap, char*)) == 0)
    80200390:	f9843783          	ld	a5,-104(s0)
    80200394:	00878713          	addi	a4,a5,8
    80200398:	f8e43c23          	sd	a4,-104(s0)
    8020039c:	6384                	ld	s1,0(a5)
    8020039e:	cc89                	beqz	s1,802003b8 <print+0x15a>
      for(; *s; s++)
    802003a0:	0004c503          	lbu	a0,0(s1)
    802003a4:	d90d                	beqz	a0,802002d6 <print+0x78>
        cons_putc(*s);
    802003a6:	00000097          	auipc	ra,0x0
    802003aa:	d18080e7          	jalr	-744(ra) # 802000be <cons_putc>
      for(; *s; s++)
    802003ae:	0485                	addi	s1,s1,1
    802003b0:	0004c503          	lbu	a0,0(s1)
    802003b4:	f96d                	bnez	a0,802003a6 <print+0x148>
    802003b6:	b705                	j	802002d6 <print+0x78>
        s = "(null)";
    802003b8:	00000497          	auipc	s1,0x0
    802003bc:	11048493          	addi	s1,s1,272 # 802004c8 <cpuid+0x56>
      for(; *s; s++)
    802003c0:	02800513          	li	a0,40
    802003c4:	b7cd                	j	802003a6 <print+0x148>
      cons_putc('%');
    802003c6:	8556                	mv	a0,s5
    802003c8:	00000097          	auipc	ra,0x0
    802003cc:	cf6080e7          	jalr	-778(ra) # 802000be <cons_putc>
      break;
    802003d0:	b719                	j	802002d6 <print+0x78>
      cons_putc('%');
    802003d2:	8556                	mv	a0,s5
    802003d4:	00000097          	auipc	ra,0x0
    802003d8:	cea080e7          	jalr	-790(ra) # 802000be <cons_putc>
      cons_putc(c);
    802003dc:	8526                	mv	a0,s1
    802003de:	00000097          	auipc	ra,0x0
    802003e2:	ce0080e7          	jalr	-800(ra) # 802000be <cons_putc>
      break;
    802003e6:	bdc5                	j	802002d6 <print+0x78>
}
    802003e8:	70a6                	ld	ra,104(sp)
    802003ea:	7406                	ld	s0,96(sp)
    802003ec:	64e6                	ld	s1,88(sp)
    802003ee:	6946                	ld	s2,80(sp)
    802003f0:	69a6                	ld	s3,72(sp)
    802003f2:	6a06                	ld	s4,64(sp)
    802003f4:	7ae2                	ld	s5,56(sp)
    802003f6:	7b42                	ld	s6,48(sp)
    802003f8:	7ba2                	ld	s7,40(sp)
    802003fa:	7c02                	ld	s8,32(sp)
    802003fc:	6ce2                	ld	s9,24(sp)
    802003fe:	6d42                	ld	s10,16(sp)
    80200400:	614d                	addi	sp,sp,176
    80200402:	8082                	ret

0000000080200404 <thread_start>:
    thread_start();
    os_main();
}

void 
thread_start(){
    80200404:	1101                	addi	sp,sp,-32
    80200406:	ec06                	sd	ra,24(sp)
    80200408:	e822                	sd	s0,16(sp)
    8020040a:	e426                	sd	s1,8(sp)
    8020040c:	1000                	addi	s0,sp,32
    uint id = cpuid();
    8020040e:	00000097          	auipc	ra,0x0
    80200412:	064080e7          	jalr	100(ra) # 80200472 <cpuid>
    80200416:	0005049b          	sext.w	s1,a0
    int i;
    for(i = 0;i < NCPU ;i++){
        if(i != id)
    8020041a:	c09d                	beqz	s1,80200440 <thread_start+0x3c>
            sbi_hsm_hart_star(i);
    8020041c:	4501                	li	a0,0
    8020041e:	00000097          	auipc	ra,0x0
    80200422:	d2e080e7          	jalr	-722(ra) # 8020014c <sbi_hsm_hart_star>
        if(i != id)
    80200426:	4785                	li	a5,1
    80200428:	00f49c63          	bne	s1,a5,80200440 <thread_start+0x3c>
            sbi_hsm_hart_star(i);
    8020042c:	4509                	li	a0,2
    8020042e:	00000097          	auipc	ra,0x0
    80200432:	d1e080e7          	jalr	-738(ra) # 8020014c <sbi_hsm_hart_star>
    }
    80200436:	60e2                	ld	ra,24(sp)
    80200438:	6442                	ld	s0,16(sp)
    8020043a:	64a2                	ld	s1,8(sp)
    8020043c:	6105                	addi	sp,sp,32
    8020043e:	8082                	ret
            sbi_hsm_hart_star(i);
    80200440:	4505                	li	a0,1
    80200442:	00000097          	auipc	ra,0x0
    80200446:	d0a080e7          	jalr	-758(ra) # 8020014c <sbi_hsm_hart_star>
        if(i != id)
    8020044a:	4789                	li	a5,2
    8020044c:	fef485e3          	beq	s1,a5,80200436 <thread_start+0x32>
    80200450:	bff1                	j	8020042c <thread_start+0x28>

0000000080200452 <start>:
start(){
    80200452:	1141                	addi	sp,sp,-16
    80200454:	e406                	sd	ra,8(sp)
    80200456:	e022                	sd	s0,0(sp)
    80200458:	0800                	addi	s0,sp,16
    thread_start();
    8020045a:	00000097          	auipc	ra,0x0
    8020045e:	faa080e7          	jalr	-86(ra) # 80200404 <thread_start>
    os_main();
    80200462:	00000097          	auipc	ra,0x0
    80200466:	bbc080e7          	jalr	-1092(ra) # 8020001e <os_main>
}
    8020046a:	60a2                	ld	ra,8(sp)
    8020046c:	6402                	ld	s0,0(sp)
    8020046e:	0141                	addi	sp,sp,16
    80200470:	8082                	ret

0000000080200472 <cpuid>:
#include "utils.h"
#include "riscv.h"
#include "types.h"

uint 
cpuid(){
    80200472:	1141                	addi	sp,sp,-16
    80200474:	e422                	sd	s0,8(sp)
    80200476:	0800                	addi	s0,sp,16


static inline uint64 
r_tp(){
    uint64 x;
    asm volatile(
    80200478:	8512                	mv	a0,tp
    uint x;
    x = r_tp();
    return x;
    8020047a:	2501                	sext.w	a0,a0
    8020047c:	6422                	ld	s0,8(sp)
    8020047e:	0141                	addi	sp,sp,16
    80200480:	8082                	ret
