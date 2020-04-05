CC = gcc
CFLAGS = -static-libgcc -pthread -fPIC -O2
INCLUDES = -I/usr/include/python3.8d -I/usr/lib/python3.8/site-packages/numpy/core/include
LDFLAGS = -L/usr/lib/x86_64-linux-gnu -lpython3.8d
TARGET = cbot

all: cidc.exe $(TARGET)0.exe $(TARGET)1.exe $(TARGET)2.exe $(TARGET)3.exe $(TARGET)4.exe $(TARGET)5.exe $(TARGET)6.exe $(TARGET)7.exe $(TARGET)8.exe $(TARGET)9.exe

cidc.exe: cidc.c
	$(CC) $(CFLAGS) $(INCLUDES) $(LDFLAGS) -o cidc.exe cidc.c

$(TARGET)0.exe: $(TARGET)0.c
	$(CC) $(CFLAGS) $(INCLUDES) $(LDFLAGS) -o $(TARGET)0.exe $(TARGET)0.c

$(TARGET)1.exe: $(TARGET)1.c
	$(CC) $(CFLAGS) $(INCLUDES) $(LDFLAGS) -o $(TARGET)1.exe $(TARGET)1.c

$(TARGET)2.exe: $(TARGET)2.c
	$(CC) $(CFLAGS) $(INCLUDES) $(LDFLAGS) -o $(TARGET)2.exe $(TARGET)2.c

$(TARGET)3.exe: $(TARGET)3.c
	$(CC) $(CFLAGS) $(INCLUDES) $(LDFLAGS) -o $(TARGET)3.exe $(TARGET)3.c

$(TARGET)4.exe: $(TARGET)4.c
	$(CC) $(CFLAGS) $(INCLUDES) $(LDFLAGS) -o $(TARGET)4.exe $(TARGET)4.c

$(TARGET)5.exe: $(TARGET)5.c
	$(CC) $(CFLAGS) $(INCLUDES) $(LDFLAGS) -o $(TARGET)5.exe $(TARGET)5.c

$(TARGET)6.exe: $(TARGET)6.c
	$(CC) $(CFLAGS) $(INCLUDES) $(LDFLAGS) -o $(TARGET)6.exe $(TARGET)6.c

$(TARGET)7.exe: $(TARGET)7.c
	$(CC) $(CFLAGS) $(INCLUDES) $(LDFLAGS) -o $(TARGET)7.exe $(TARGET)7.c

$(TARGET)8.exe: $(TARGET)8.c
	$(CC) $(CFLAGS) $(INCLUDES) $(LDFLAGS) -o $(TARGET)8.exe $(TARGET)8.c

$(TARGET)9.exe: $(TARGET)9.c
	$(CC) $(CFLAGS) $(INCLUDES) $(LDFLAGS) -o $(TARGET)9.exe $(TARGET)9.c

cidc.c:
	python3.8 -m cython -3 --embed cidc.pyx

$(TARGET)0.c:
	cat cbot.pyx bot_instances/0.pyx async_funcs/0.pyx > cbot0.pyx
	python3.8 -m cython -3 --embed $(TARGET)0.pyx

$(TARGET)1.c:
	cat cbot.pyx bot_instances/1.pyx async_funcs/1.pyx > cbot1.pyx
	python3.8 -m cython -3 --embed $(TARGET)1.pyx

$(TARGET)2.c:
	cat cbot.pyx bot_instances/2.pyx async_funcs/2.pyx > cbot2.pyx
	python3.8 -m cython -3 --embed $(TARGET)2.pyx

$(TARGET)3.c:
	cat cbot.pyx bot_instances/3.pyx async_funcs/3.pyx > cbot3.pyx
	python3.8 -m cython -3 --embed $(TARGET)3.pyx

$(TARGET)4.c:
	cat cbot.pyx bot_instances/4.pyx async_funcs/4.pyx > cbot4.pyx
	python3.8 -m cython -3 --embed $(TARGET)4.pyx

$(TARGET)5.c:
	cat cbot.pyx bot_instances/5.pyx async_funcs/5.pyx > cbot5.pyx
	python3.8 -m cython -3 --embed $(TARGET)5.pyx

$(TARGET)6.c:
	cat cbot.pyx bot_instances/6.pyx async_funcs/6.pyx > cbot6.pyx
	python3.8 -m cython -3 --embed $(TARGET)6.pyx

$(TARGET)7.c:
	cat cbot.pyx bot_instances/7.pyx async_funcs/7.pyx > cbot7.pyx
	python3.8 -m cython -3 --embed $(TARGET)7.pyx

$(TARGET)8.c:
	cat cbot.pyx bot_instances/8.pyx async_funcs/8.pyx > cbot8.pyx
	python3.8 -m cython -3 --embed $(TARGET)8.pyx

$(TARGET)9.c:
	cat cbot.pyx bot_instances/9.pyx async_funcs/9.pyx > cbot9.pyx
	python3.8 -m cython -3 --embed $(TARGET)9.pyx

clean:
	$(RM) $(TARGET)0.pyx $(TARGET)1.pyx $(TARGET)2.pyx $(TARGET)3.pyx $(TARGET)4.pyx $(TARGET)5.pyx $(TARGET)6.pyx $(TARGET)7.pyx $(TARGET)8.pyx $(TARGET)9.pyx *.c *.exe

clear:
	$(RM) $(TARGET)0.pyx $(TARGET)1.pyx $(TARGET)2.pyx $(TARGET)3.pyx $(TARGET)4.pyx $(TARGET)5.pyx $(TARGET)6.pyx $(TARGET)7.pyx $(TARGET)8.pyx $(TARGET)9.pyx *.c
