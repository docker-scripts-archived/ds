PREFIX ?= /usr
DESTDIR ?=
BINDIR ?= $(DESTDIR)$(PREFIX)/bin
LIBDIR ?= $(DESTDIR)$(PREFIX)/lib
MANDIR ?= $(DESTDIR)$(PREFIX)/share/man/man1
BASHCOMP_PATH ?= $(DESTDIR)$(PREFIX)/share/bash-completion/completions

DS = $(BINDIR)/ds
LIB = $(LIBDIR)/ds

all: man install

install: uninstall
	@install -v -d "$(LIB)/"
	@cp -v -r sh/* "$(LIB)/"

	@install -v -d "$(BINDIR)/"
	@mv -v "$(LIB)"/docker.sh "$(DS)"
	@sed -i "$(DS)" -e "s#LIBDIR=.*#LIBDIR=\"$(LIB)\"#"
	@chmod -c 0755 "$(DS)"

	@install -v -d "$(BASHCOMP_PATH)"
	@mv -v "$(LIB)"/bash-completion.sh "$(BASHCOMP_PATH)"/ds
	@chmod -c 0644 "$(BASHCOMP_PATH)"/ds

	@install -v -d "$(MANDIR)/"
	@install -v -m 0644 man/ds.1 "$(MANDIR)/ds.1"

uninstall:
	@rm -vrf "$(DS)" "$(LIB)" "$(MANDIR)/ds.1" "$(BASHCOMP_PATH)"/ds

man: man/ds.1 man/ds.1.html

man/ds.1 man/ds.1.html: man/ds.1.ronn
	@man/make.sh

TESTS = $(sort $(wildcard tests/t*.t))

test: $(TESTS)

$(TESTS):
	@$@ $(DS_TEST_OPTS)

clean:
	$(RM) -rf tests/test-results/ tests/trash\ directory.*/
	$(RM) -f man/ds.1 man/ds.1.html

.PHONY: install uninstall test clean $(TESTS)
