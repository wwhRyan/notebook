# FreeRTOS

RTOS是一个嵌入式工程师的基本功,在基本功上下功夫是非常有用的.开发其他的工程事半功倍的效果.

## 移植 FreeRTOS
1. 下载FreeRTOS源码，包含两个目录FreeRTOS/和FreeRTOS-Plus/,其中FreeRTOS/是核心功能,FreeRTOS-Plus/是应用工具.
2. 将FreeRTOS/Source中除了portable/的文件复制到工程中,FreeRTOS/Source/portable/中选择对应的内存分配策略MemMang/,选择对应的编译器与MCU,例如GCC/ARM_CM4F/,复制到工程中.
3. 修改对应FreeRTOSConfig.h参数,设置对应的功能,可以参考Demo中对应的配置(FreeRTOS/Demo/CORTEX_M4F_STM32F407ZG-SK/FreeRTOSConfig.h)
4. 修改中断配置**_it.c,将 SVCHandler()， PendSV_Handler()，SysTick_Handler() 三個函数前面加上 __attribute((weak)),freeRTOS中会覆盖此三个中断函数
5. main.c文件中增加#include "FreeRTOS.h" 和 #include "task.h",增加 vApplicationMallocFailedHook() ， vApplicationIdleHook() 和 vApplicationStackOverflowHook() 
6. 增加空闲钩子函数vApplicationTickHook() 
7. 中断修改为抢占式中断,NVIC_PriorityGroupConfig(NVIC_PriorityGroup_4);