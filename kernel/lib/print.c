#include "sbi.h"
#include "types.h"
#include "print.h"

typedef __builtin_va_list va_list;
#define va_start(ap, param) __builtin_va_start(ap, param)
#define va_end(ap)          __builtin_va_end(ap)
#define va_arg(ap, type)    __builtin_va_arg(ap, type)


volatile int panicked = 0;

static char digits[] = "0123456789abcdef";

void panic(char *s);


static void
printint(int xx, int base, int sign)
{
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    x = -xx;
  else
    x = xx;

  i = 0;
  do {
    buf[i++] = digits[x % base];
  } while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
    cons_putc(buf[i]);
}

static void
printptr(uint64 x)
{
  int i;
  cons_putc('0');
  cons_putc('x');
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    cons_putc(digits[x >> (sizeof(uint64) * 8 - 4)]);
}

// Print to the console. only understands %d, %x, %p, %s.
void
print(char *fmt, ...)
{
  va_list ap;
  int i, c;
  char *s;
  if (fmt == 0)
    panic("null fmt");

  va_start(ap, fmt);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    if(c != '%'){
      cons_putc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
    switch(c){
    case 'd':
      printint(va_arg(ap, int), 10, 1);
      break;
    case 'x':
      printint(va_arg(ap, int), 16, 1);
      break;
    case 'p':
      printptr(va_arg(ap, uint64));
      break;
    case 's':
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s; s++)
        cons_putc(*s);
      break;
    case '%':
      cons_putc('%');
      break;
    default:
      // Print unknown % sequence to draw attention.
      cons_putc('%');
      cons_putc(c);
      break;
    }
  }
  va_end(ap);

}

void
panic(char *s)
{
  print("panic: ");
  print(s);
  print("\n");
  panicked = 1; // freeze uart output from other CPUs
  for(;;)
    ;
}