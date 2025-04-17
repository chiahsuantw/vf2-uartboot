#!/bin/sh

# This script sends the kernel image to VF2 via UART

DEVICE_PATH=$1
KERNEL_PATH=$2

# Check the root permission
if [ "$(id -u)" != "0" ]; then
    echo "This script must be run as root"
    exit 1
fi

# Get the size of the kernel image and send it to VF2
# wc -c: print byte counts of a file
# sleep: pause for n seconds
wc -c < $KERNEL_PATH > $DEVICE_PATH | sleep 1

# Send the kernel image
# pv: redirect the input to a specified tty device
#     add the --rate-limit <n> option to limit the rate
pv $KERNEL_PATH > $DEVICE_PATH
