# Raspberry Pi Monitor App

(Theoretically it should work on any arm/x86 linux machine, but I can't guarantee.)

Prerelease download link: [https://cloud.pegasis.site/s/HoXZEs7wLecMrsZ](https://cloud.pegasis.site/s/HoXZEs7wLecMrsZ)

## Features

- Zero setup
- Nothing will be installed on the raspberry pi

## How does this work?

1. Upload [Raspberry Pi Monitor](https://github.com/PegasisForever/raspi_monitor) binary to the rpi `/var/tmp/` by sftp.
2. Use ssh to run that binary every minute to get data.

## Compile Release

```
flutter build apk --target-platform android-arm64,android-arm --split-per-abi --no-shrink
```
