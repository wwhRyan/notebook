# printf

## 单个字符输出
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

## 字符buffer输出
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

## printf 的内部实现

不同的编译器会有不同的处理方式，例如：
- printf -> uart输出函数
- printf -> _Printf（stdio）-> putchar -> uart输出函数
- printf -> _Printf（stdio）-> fputc -> uart输出函数
printf的声明在stdio.h中`int printf(const char *fmt, ...)`,printf的实现可能在源文件或者封装成`libio.a`,具体参考`stdio.h`看其具体实现方式.

如果编译环境配置printf不一样，这个内部实现也可能需要很多的存储空间。最节省空间的就是直接覆盖printf函数.

## 中断不能调用printf

以9600，1个起始位，1个停止位，8个数据位的常见方式为例,传输一个字节要1个毫秒,几个毫秒过去,MCU的其他功能都卡住了,会错失很多其他的中断或者任务.

另外,由于线程安全,一般会给printf加上锁.中断不能获取锁,因此会发生死锁问题.

## printf 线程安全

printf是线程不安全的,需要
- 给printf加锁.
- 开辟一个环形缓冲区,不要同步打印，先将数据打印到内存，主函数中打印
- RTOS可以开辟Stream buffer,数据输入到Stream buffer,在低优先级任务中打印
