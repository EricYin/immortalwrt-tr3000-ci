$file = ".\bdinfo.bin"
Copy-Item $file "$file.bak"

$offset = 0xDE00
$mac = [byte[]](0xFC, 0xA0, 0x5A, 0x30, 0x3F, 0x6C)

$bytes = [System.IO.File]::ReadAllBytes($file)
$bytes[$offset..($offset + 5)] = $mac
[System.IO.File]::WriteAllBytes($file, $bytes)

$bytes[$offset..($offset + 5)] |
    ForEach-Object { $_.ToString("X2") } -join ":"

hexdump -v -n 6 -s 0xde00 -e '5/1 "%02X:" 1/1 "%02X\n"' /tmp/bdinfo.bin
mtd write /tmp/bdinfo.fixed.bin bdinfo
