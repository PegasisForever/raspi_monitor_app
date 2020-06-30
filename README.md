# Raspberry Pi Monitor App

(Theoretically it should work on any arm/x86 linux machine, but I can't guarantee.)

Prerelease download link: [https://cloud.pegasis.site/s/HoXZEs7wLecMrsZ](https://cloud.pegasis.site/s/HoXZEs7wLecMrsZ)

## Screenshots

![](https://cloud.pegasis.site/s/Sj4EKD2p5t2LBS3/preview)
![](https://cloud.pegasis.site/s/yX48mbrQxk68xsG/preview)
![](https://cloud.pegasis.site/s/rWz9HrAeiC3j4tZ/preview)
![](https://cloud.pegasis.site/s/BM6Y8Y7RBjySCkQ/preview)

## Features

- Zero setup
- Nothing will be installed on the raspberry pi

## How does this work?

1. Upload [Raspberry Pi Monitor](https://github.com/PegasisForever/raspi_monitor) binary to the rpi `/var/tmp/` by sftp.
2. Use ssh to run that binary every second to get data.

## Compile Release

```
flutter build apk --target-platform android-arm64,android-arm --split-per-abi --no-shrink
```
