SHELL = bash -o pipefail -c
PREFIX ?= /usr


default : check

check :
	@ $(MAKE) -k --no-print-directory -C test ; rc=$$? ; $(MAKE) --no-print-directory -C test report ; exit $$rc

install :
	install -m 0755 -o root -g root -d $(DESTDIR)$(PREFIX)/bin
	install -m 0755 -o root -g root -t $(DESTDIR)$(PREFIX)/bin $(CURDIR)/bin/*
	install -m 0755 -o root -g root -d $(DESTDIR)/etc
	install -m 0640 -o root -g root $(CURDIR)/etc/deployer.example.conf $(DESTDIR)/etc/deployer.conf
	install -m 0755 -o root -g root -d $(DESTDIR)/etc/service
	tar cf - etc/service | ( cd $(DESTDIR) && tar xvf - )

