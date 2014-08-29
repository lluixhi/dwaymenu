# dwaymenu - dynamic wayland menu
# See LICENSE file for copyright and license details.

include config.mk

SRC = dwaymenu.c draw.c stest.c
OBJ = ${SRC:.c=.o}

all: options dwaymenu stest

options:
	@echo dwaymenu build options:
	@echo "CFLAGS   = ${CFLAGS}"
	@echo "LDFLAGS  = ${LDFLAGS}"
	@echo "CC       = ${CC}"

.c.o:
	@echo CC -c $<
	@${CC} -c $< ${CFLAGS}

config.h:
	@echo creating $@ from config.def.h
	@cp config.def.h $@

${OBJ}: config.h config.mk draw.h

dwaymenu: dwaymenu.o draw.o
	@echo CC -o $@
	@${CC} -o $@ dwaymenu.o draw.o ${LDFLAGS}

stest: stest.o
	@echo CC -o $@
	@${CC} -o $@ stest.o ${LDFLAGS}

clean:
	@echo cleaning
	@rm -f dwaymenu stest ${OBJ} dwaymenu-${VERSION}.tar.gz

dist: clean
	@echo creating dist tarball
	@mkdir -p dwaymenu-${VERSION}
	@cp LICENSE Makefile README config.mk dwaymenu.1 draw.h dwaymenu_path dwaymenu_run stest.1 ${SRC} dwaymenu-${VERSION}
	@tar -cf dwaymenu-${VERSION}.tar dwaymenu-${VERSION}
	@gzip dwaymenu-${VERSION}.tar
	@rm -rf dwaymenu-${VERSION}

install: all
	@echo installing executables to ${DESTDIR}${PREFIX}/bin
	@mkdir -p ${DESTDIR}${PREFIX}/bin
	@cp -f dwaymenu dwaymenu_path dwaymenu_run stest ${DESTDIR}${PREFIX}/bin
	@chmod 755 ${DESTDIR}${PREFIX}/bin/dwaymenu
	@chmod 755 ${DESTDIR}${PREFIX}/bin/dwaymenu_path
	@chmod 755 ${DESTDIR}${PREFIX}/bin/dwaymenu_run
	@chmod 755 ${DESTDIR}${PREFIX}/bin/stest
	@echo installing manual pages to ${DESTDIR}${MANPREFIX}/man1
	@mkdir -p ${DESTDIR}${MANPREFIX}/man1
	@sed "s/VERSION/${VERSION}/g" < dwaymenu.1 > ${DESTDIR}${MANPREFIX}/man1/dwaymenu.1
	@sed "s/VERSION/${VERSION}/g" < stest.1 > ${DESTDIR}${MANPREFIX}/man1/stest.1
	@chmod 644 ${DESTDIR}${MANPREFIX}/man1/dwaymenu.1
	@chmod 644 ${DESTDIR}${MANPREFIX}/man1/stest.1

uninstall:
	@echo removing executables from ${DESTDIR}${PREFIX}/bin
	@rm -f ${DESTDIR}${PREFIX}/bin/dwaymenu
	@rm -f ${DESTDIR}${PREFIX}/bin/dwaymenu_path
	@rm -f ${DESTDIR}${PREFIX}/bin/dwaymenu_run
	@rm -f ${DESTDIR}${PREFIX}/bin/stest
	@echo removing manual page from ${DESTDIR}${MANPREFIX}/man1
	@rm -f ${DESTDIR}${MANPREFIX}/man1/dwaymenu.1
	@rm -f ${DESTDIR}${MANPREFIX}/man1/stest.1

.PHONY: all options clean dist install uninstall
