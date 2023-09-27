# mdwm - dynamic window manager
# See LICENSE file for copyright and license details.

include config.mk

SRC = drw.c mdwm.c util.c
OBJ = ${SRC:.c=.o}

all: options mdwm

options:
	@echo mdwm build options:
	@echo "CFLAGS   = ${CFLAGS}"
	@echo "LDFLAGS  = ${LDFLAGS}"
	@echo "CC       = ${CC}"

.c.o:
	${CC} -c ${CFLAGS} $<

${OBJ}: config.h config.mk

config.h:
	cp config.def.h $@

mdwm: ${OBJ}
	${CC} -o $@ ${OBJ} ${LDFLAGS}

clean:
	rm -f mdwm ${OBJ} mdwm-${VERSION}.tar.gz

dist: clean
	mkdir -p mdwm-${VERSION}
	cp -R LICENSE Makefile README config.def.h config.mk\
		mdwm.1 drw.h util.h ${SRC} mdwm.png transient.c mdwm-${VERSION}
	tar -cf mdwm-${VERSION}.tar mdwm-${VERSION}
	gzip mdwm-${VERSION}.tar
	rm -rf mdwm-${VERSION}

install: all
	mkdir -p ${DESTDIR}${PREFIX}/bin
	cp -f mdwm ${DESTDIR}${PREFIX}/bin
	chmod 755 ${DESTDIR}${PREFIX}/bin/mdwm
	mkdir -p ${DESTDIR}${MANPREFIX}/man1
	sed "s/VERSION/${VERSION}/g" < mdwm.1 > ${DESTDIR}${MANPREFIX}/man1/mdwm.1
	chmod 644 ${DESTDIR}${MANPREFIX}/man1/mdwm.1

uninstall:
	rm -f ${DESTDIR}${PREFIX}/bin/mdwm\
		${DESTDIR}${MANPREFIX}/man1/mdwm.1

.PHONY: all options clean dist install uninstall
