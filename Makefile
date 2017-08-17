SHELL = bash -o pipefail -c
PREFIX ?= /usr


default : check

check :
	@ $(MAKE) -k --no-print-directory -C test ; rc=$$? ; $(MAKE) --no-print-directory -C test report ; exit $$rc

install :
	install -d $(DESTDIR)$(PREFIX)/bin
	find $(CURDIR)/bin -type f -print0 | xargs -0 -n1 -I@ install -m 0755 @ $(DESTDIR)$(PREFIX)/bin
	install -d $(DESTDIR)/etc
	install -m 0640 $(CURDIR)/etc/deployer.example.conf $(DESTDIR)/etc/deployer.conf
	install -d $(DESTDIR)/etc/service
	tar cf - etc/service | ( cd $(DESTDIR) && tar xvf - )

