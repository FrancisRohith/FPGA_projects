import serial
import time

ser = serial.Serial("COM6", 115200)
if ser.is_open:
    print(f"{ser.name} is open...")
val = ''
while True:
    bs = ser.read(1)
    bs1 = ser.read(1)
    print(bs)
    print(bs1)
