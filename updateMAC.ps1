
$file='C:\tr3000\spi_full_bak\bdinfo.bin'
Copy-Item $file "$file.bak"

$offset = 0xDE00
$mac = [byte[]](0xFD, 0xA1, 0x5B, 0x31, 0x40, 0x6D)

$bytes = [System.IO.File]::ReadAllBytes($file)
# Properly copy the MAC address bytes into the array
for ($i = 0; $i -lt $mac.Length; $i++) {
    $bytes[$offset + $i] = $mac[$i]
}

[System.IO.File]::WriteAllBytes($file, $bytes)

//run cmd below after you copy bdinfo.bin to your router path /tmp/bdinfo.bin
$bytes[$offset..($offset+5)] | ForEach-Object { '{0:X2}' -f $_ }
hexdump -v -n 6 -s 0xde00 -e '5/1 "%02X:" 1/1 "%02X\n"' /tmp/bdinfo.bin
insmod mtd-rw.ko i_want_a_brick=1
mtd write /tmp/bdinfo.bin bdinfo
