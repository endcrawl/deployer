SHELL = bash -o pipefail -c


default :

check :
	@ $(MAKE) -k --no-print-directory -C test ; rc=$$? ; $(MAKE) --no-print-directory -C test report ; exit $$rc

