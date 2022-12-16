# printf

# 单个字符输出
```c
/* printf is not thread safety, but can muti thread bug. */
/* retarget the C library printf function to the USART */
int fputc(int ch, FILE* f)
{
    usart_data_transmit(EVAL_COM1, (uint8_t)ch);
    while (RESET == usart_flag_get(EVAL_COM1, USART_FLAG_TBE))
        ;

    return ch;
}

int fgetc(FILE* f)
{
    while (RESET == usart_flag_get(EVAL_COM1, USART_FLAG_RBNE))
        ;
    return (int)usart_data_receive(EVAL_COM1);
}
```

# 字符buffer输出
```c
// 重定义printf函数
int printf(const char* fmt, ...)
{
    char buf[128] = {0};

    va_list args;

    va_start(args, fmt);
    vsnprintf(buf, sizeof(buf), fmt, args);
    va_end(args);

    Uart_SyncSend(UART_LPUART_INTERNAL_CHANNEL, (const uint8*)buf, strlen(buf), 0xffffffff);
    return 0;
}
```