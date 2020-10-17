CC = gcc
CFLAGS = -static-libgcc -O2 -fPIC
INCLUDES = -I/usr/include/python3.9d -I/usr/lib/python3.9/site-packages/numpy/core/include
LDFLAGS = -L/usr/lib/x86_64-linux-gnu -lpython3.9d -lm
TARGET0 = cidc
TARGET1 = cbot

all: $(TARGET0) $(TARGET1)

$(TARGET0): $(TARGET0).c
	$(CC) $(CFLAGS) $(INCLUDES) $(LDFLAGS) -o $(TARGET0) $(TARGET0).c 

$(TARGET1): $(TARGET1).c
	$(CC) $(CFLAGS) $(INCLUDES) $(LDFLAGS) -o $(TARGET1) $(TARGET1).c

$(TARGET0).c:
	python3.9 -m cython -3 --embed $(TARGET0).pyx

$(TARGET1).c:
	python3.9 -m cython -3 --embed $(TARGET1).pyx

clean:
	$(RM) *.c $(TARGET0) $(TARGET1)

clear:
	$(RM) *.c
