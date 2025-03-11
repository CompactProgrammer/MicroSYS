import os

# Variables
image = "images/disk1.iso"
wantedsize =  6291456
wantedsizestr = "6MB"

append = open(image, "ab")
appendstats = os.stat(image)
size = appendstats.st_size
print("Built image size: " + str(size))

if (size > wantedsize):
    print ("Built image is greater than " + wantedsizestr)
    exit()

while size < wantedsize:
    append.write(b"\x00")
    size += 1
    
print(wantedsizestr + " image size: " + str(size))
append.close()