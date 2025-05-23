#define UART_BASE 0x10000000UL
#define UART_RBR  (unsigned int *)(UART_BASE + 0x0)
#define UART_THR  (unsigned int *)(UART_BASE + 0x0)
#define UART_LSR  (unsigned int *)(UART_BASE + 0x14)

#define BUF_SIZE 16

extern char _load_start[];

char uart_recv();
void uart_putc(char c);
void uart_puts(const char *s);
void uart_hex(unsigned long h);
int atoi(const char *s);

void main(long hartid, long dbt_addr)
{
    uart_puts("\nVF2 UART Booltloader\n");

    char buffer[BUF_SIZE];
    for (int i = 0; i < BUF_SIZE; i++) {
        buffer[i] = uart_recv();
        if (buffer[i] == '\n') {
            buffer[i] = '\0';
            break;
        }
    }

    int size = atoi(buffer);
    uart_puts("[INFO] Kernel size = ");
    uart_hex(size);
    uart_puts("\n");

    char *data = (char *)_load_start;
    while (size--)
        *data++ = uart_recv();

    uart_puts("Booting...\n");
    asm("fence.i");
    ((typeof(&main))(_load_start))(hartid, dbt_addr);
}

char uart_recv()
{
    while ((*UART_LSR & 0x01) == 0)
        ;
    return (char)*UART_RBR;
}

void uart_putc(char c)
{
    if (c == '\n')
        uart_putc('\r');
    while ((*UART_LSR & 0x20) == 0)
        ;
    *UART_THR = c;
}

void uart_puts(const char *s)
{
    while (*s) {
        uart_putc(*s++);
    }
}

void uart_hex(unsigned long h)
{
    uart_puts("0x");
    unsigned long n;
    for (int c = 28; c >= 0; c -= 4) {
        n = (h >> c) & 0xf;
        n += n > 9 ? 0x37 : '0';
        uart_putc(n);
    }
}

int atoi(const char *s)
{
    int ret = 0;
    int i = 0;
    while (s[i] == ' ')
        i++;
    while (s[i] >= '0' && s[i] <= '9') {
        ret = ret * 10 + (s[i] - '0');
        i++;
    }
    return ret;
}

void *memcpy(void *dst, const void *src, int n)
{
    char *d = dst;
    const char *s = src;
    while (n--)
        *d++ = *s++;
    return dst;
}
