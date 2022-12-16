# UART

UART中断字符接收
```c
typedef struct
{
	uint8_t Data[100];
	uint8_t Length;
}Usart_Sdu_Type;

void __attribute__((interrupt)) _USART0_exception (void)
{
	if(USART_Get_Receive_Frame_Idel_Flag(USART0_SFR))
	{
		Rx_Flag = 1;
		Usart_Receive_Sdu.Length = 0;
		while(Usart_Receive_Sdu.Data[Usart_Receive_Sdu.Length] != '\r')
		{
			Usart_Receive_Sdu.Length++;
		}
		Usart_Receive_Sdu.Length += 2 ;
		USART_Clear_Idle_INT_Flag(USART0_SFR);
	}
}
```