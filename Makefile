# mwm - dynamic window manager
# See LICENSE file for copyright and license details.

include config.mk

SRC = drw.c mwm.c util.c
OBJ = ${SRC:.c=.o}

all: options mwm

options:
	@echo mwm build options:
	@echo "CFLAGS   = ${CFLAGS}"
	@echo "LDFLAGS  = ${LDFLAGS}"
	@echo "CC       = ${CC}"

.c.o:
	${CC} -c ${CFLAGS} $<

${OBJ}: config.h config.mk

config.h:
	cp config.def.h $@

mwm: ${OBJ}
	${CC} -o $@ ${OBJ} ${LDFLAGS}

clean:
	rm -f mwm ${OBJ} mwm-${VERSION}.tar.gz

dist: clean
	mkdir -p mwm-${VERSION}
	cp -R LICENSE Makefile README config.def.h config.mk\
		mwm.1 drw.h util.h ${SRC} mwm.png transient.c mwm-${VERSION}
	tar -cf mwm-${VERSION}.tar mwm-${VERSION}
	gzip mwm-${VERSION}.tar
	rm -rf mwm-${VERSION}

install: all
	mkdir -p ${DESTDIR}${PREFIX}/bin
	cp -f mwm ${DESTDIR}${PREFIX}/bin
	chmod 755 ${DESTDIR}${PREFIX}/bin/mwm
	mkdir -p ${DESTDIR}${MANPREFIX}/man1
	sed "s/VERSION/${VERSION}/g" < mwm.1 > ${DESTDIR}${MANPREFIX}/man1/mwm.1
	chmod 644 ${DESTDIR}${MANPREFIX}/man1/mwm.1

uninstall:
	rm -f ${DESTDIR}${PREFIX}/bin/mwm\
		${DESTDIR}${MANPREFIX}/man1/mwm.1

.PHONY: all options clean dist install uninstall
