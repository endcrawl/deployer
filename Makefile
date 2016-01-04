SHELL = bash -o pipefail -c
PATH := $(PATH):$(CURDIR)/bin
export PATH


default :

check :
	@ $(MAKE) -k --no-print-directory -C test ; rc=$$? ; $(MAKE) --no-print-directory -C test report ; exit $$rc

