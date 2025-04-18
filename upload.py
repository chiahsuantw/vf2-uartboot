import serial
import sys
import time

ser = serial.Serial(sys.argv[1], 115200)

with open(sys.argv[2], "rb") as file:
    data = file.read()
    ser.write((str(len(data)) + "\n").encode())
    time.sleep(1)
    ser.write(data)

ser.close()
