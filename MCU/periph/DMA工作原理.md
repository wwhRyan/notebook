# DMA

DMA，全称Direct Memory Access，即直接存储器访问。

DMA传输将数据从一个地址空间复制到另一个地址空间，提供外设到内存, 内存到外设, 外设到外设, 内存到内存的数据传输。

## 特点

- 传输宽度（字节、半字、全字），模拟打包和拆包的过程。源和目标地址必须按数据传输宽度对齐
- 支持循环的缓冲器管理，最大数目为65535
- 3个事件标志（DMA半传输、DMA传输完成和DMA传输出错），这三个事件可以作为中断触发源