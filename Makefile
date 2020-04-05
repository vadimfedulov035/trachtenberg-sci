CC = gcc
CFLAGS = -static-libgcc -pthread -fPIC -O2
INCLUDES = -I/usr/include/python3.8d -I/usr/lib/python3.8/site-packages/numpy/core/include
LDFLAGS = -L/usr/lib/x86_64-linux-gnu -lpython3.8d
TARGET = cbot

all: $(TARGET).exe

$(TARGET).exe: $(TARGET).c
	$(CC) $(CFLAGS) $(INCLUDES) $(LDFLAGS) -o $(TARGET).exe $(TARGET).c

$(TARGET).c:
	python3.8 -m cython -3 --embed $(TARGET).pyx

clean:
	$(RM) *.c *.exe

