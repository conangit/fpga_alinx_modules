VGA显示标准 800*600@60Hz

图片信息
分辨率80*86
位深1bit
即每个plex使用1bit(1-亮 0-灭)表示
共计80*86*1bit=860byte

ROM信息排布

0: 1bit 1bit ... 1bit (80个1bit=80bit)
1: 1bit 1bit ... 1bit
...
...
...
85:...............79

rom_addr:y(0~85)-->max=85(7bit)
rom_data width: 80bit