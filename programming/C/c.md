# C

## 字符串操作

```c
#include <stdio.h>
#include <string.h>
 
/**
 * @brief string replace, The stack is used for temporary storage of strings, so the length is limited
 * 
 * @param dest string to be replaced
 * @param oldstr old string replaced
 * @param newstr new string after replacement
 * @return char* string pointer after replacement
 */
char* strrpc(char* dest, char* oldstr, char* newstr)
{
    char buff[512] = { 0 };
    size_t dest_size = strlen(dest);
    size_t oldstr_size = strlen(oldstr);
    size_t newstr_size = strlen(newstr);
 
    for (int buff_offset = 0, dest_offset = 0; dest_offset < dest_size;) {
        if (!strncmp(dest + dest_offset, oldstr, oldstr_size)) {
            memcpy(buff + buff_offset, newstr, newstr_size);
            dest_offset += oldstr_size;
            buff_offset += newstr_size;
        } else {
            memmove(buff + buff_offset, dest + dest_offset, 1);
            dest_offset++;
            buff_offset++;
        }
    }
 
    memset(dest, 0, dest_size);
    memcpy(dest, buff, strlen(buff));
 
    return dest;
}
 
int main()
{
    char str[] = "Hello,中国!\n";
    printf("%s",str);
    strrpc(str,"中国","世界");
    printf("%s",str);
    strrpc(str,"Hello","你好");
    printf("%s",str);
    strrpc(str,"你好,世界","Hello,world");
    printf("%s",str);
    return 0;
}
```

## CRC计算

```c
#include <stdio.h>
#include <string.h>
 
int crc32_mpeg2(unsigned const char *message, size_t l)
{
    unsigned int crc, msb;
 
    crc = 0xFFFFFFFF;
    for(size_t i = 0; i < l; i++) {
        crc ^= (((unsigned int)message[i]) << 24);
 
        for (size_t j = 0; j < 8; j++) {
            msb = crc>>31;
            crc <<= 1;
            crc ^= (0 - msb) & 0x04C11DB7;
        }
    }
 
    return crc;
}
 
int main()
{
    char *str = "123456789";
    printf("CRC %#X\n",crc32_mpeg2(str,strlen(str)));
    return 0;
}
```