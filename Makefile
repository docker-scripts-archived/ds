PREFIX ?= /usr
DESTDIR ?=
BINDIR ?= $(DESTDIR)$(PREFIX)/bin
LIBDIR ?= $(DESTDIR)$(PREFIX)/lib
MANDIR ?= $(DESTDIR)$(PREFIX)/share/man/man1
BASHCOMP_PATH ?= $(DESTDIR)$(PREFIX)/share/bash-completion/completions

all: man install

install: uninstall
	install -v -d "$(LIBDIR)"/ds/
	cp -v -r sh/* "$(LIBDIR)"/ds/

	install -v -d "$(BINDIR)"/
	mv -v "$(LIBDIR)"/ds/docker.sh "$(BINDIR)"/ds
	sed -i "$(BINDIR)"/ds -e "s#LIBDIR=.*#LIBDIR=\"$(LIBDIR)/ds\"#"
	chmod -c 0755 "$(BINDIR)"/ds

	install -v -d "$(BASHCOMP_PATH)"
	mv -v "$(LIBDIR)"/ds/bash-completion.sh "$(BASHCOMP_PATH)"/ds
	chmod -c 0644 "$(BASHCOMP_PATH)"/ds

	install -v -d "$(MANDIR)/"
	install -v -m 0644 man/ds.1 "$(MANDIR)/ds.1"

uninstall:
	rm -vrf "$(BINDIR)"/ds "$(LIBDIR)/ds" "$(MANDIR)/ds.1" "$(BASHCOMP_PATH)"/ds

man: man/ds.1 man/ds.1.html

man/ds.1 man/ds.1.html: man/ds.1.ronn
	@man/make.sh

test:
	cd test/ && ds test

clean:
	rm -f man/ds.1 man/ds.1.html
	-for app in ds-test-app1 ds-test-app2 ds-test; do \
	    docker stop $$app 2>/dev/null ;\
	    docker rm   $$app 2>/dev/null ;\
	    docker rmi  $$app 2>/dev/null ;\
	done
	rm -rf test/ds-test
	rm -rf test/test-results
	rm -rf test/trash\ directory.*

.PHONY: install uninstall test clean
