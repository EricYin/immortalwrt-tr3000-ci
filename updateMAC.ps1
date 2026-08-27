$file='C:\tr3000\spi_full_bak\bdinfo.bin'
Copy-Item $file "$file.bak"

$offset = 0xDE00
$mac = [byte[]](0xFC, 0xA0, 0x5A, 0x30, 0x3F, 0x6C)

$bytes = [System.IO.File]::ReadAllBytes($file)
# Properly copy the MAC address bytes into the array
for ($i = 0; $i -lt $mac.Length; $i++) {
    $bytes[$offset + $i] = $mac[$i]
}

[System.IO.File]::WriteAllBytes($file, $bytes)

$bytes[$offset..($offset+5)] | ForEach-Object { '{0:X2}' -f $_ }
hexdump -v -n 6 -s 0xde00 -e '5/1 "%02X:" 1/1 "%02X\n"' /tmp/bdinfo.bin
insmod mtd-rw.ko i_want_a_brick=1
mtd write /tmp/bdinfo.bin bdinfo
