CC=gcc
CFLAGS=-I.
CFLAGS = -fPIC -O0 -g
LDFLAGS = -shared
LN = ln -sf
SRCS = vixDiskLib.c
OBJS = ${SRCS:.c=.o}
TARGET_LIB = libvixDiskLib.so
MAJOR_VERSION = $(shell echo ${VDDK_VERSION} | cut -f1 -d.)
VDDK_VERSION ?= 6.7.0

.PHONY: all
all: ${TARGET_LIB}.${VDDK_VERSION}

${SRCS:.c=.d}:%.d:%.c
	${CC} ${CFLAGS} -MM $< >$@

${TARGET_LIB}.${MAJOR_VERSION}: ${TARGET_LIB}
	${LN} $^ $@
${TARGET_LIB}.${VDDK_VERSION}: ${TARGET_LIB}.${MAJOR_VERSION}
	${LN} $^ $@

${TARGET_LIB}: ${OBJS}
	${CC} ${LDFLAGS} -o $@ $^

include ${SRCS:.c=.d}

.PHONY: clean
clean:
	-${RM} ${TARGET_LIB} ${TARGET_LIB}.${MAJOR_VERSION} ${TARGET_LIB}.${VDDK_VERSION} ${OBJS} ${SRCS:.c=.d}
