# python

## CRC 计算
```python
# https://crccalc.com/ 
# width=32 poly=0x04c11db7 init=0xffffffff refin=false refout=false xorout=0x00000000 check=0x0376e6e7 residue=0x00000000 name="CRC-32/MPEG-2"
# http://www.sunshine2k.de/articles/coding/crc/understanding_crc.html#ch43 (for detail understanding CRC)
def create_table():
    a = []
    for i in range(256):
        k = i << 24
        for _ in range(8):
            k = (k << 1) ^ 0x4c11db7 if k & 0x80000000 else k << 1
        a.append(k & 0xffffffff)
    return a
 
 
def crc32(bytestream, crc_table):
    crc = 0xffffffff
    for byte in bytestream:
        lookup_index = ((crc >> 24) ^ byte) & 0xff
        crc = ((crc & 0xffffff) << 8) ^ crc_table[lookup_index]
    return crc
    
crc_table = create_table()
print(hex(crc32(b'123456789', crc_table)))
```
