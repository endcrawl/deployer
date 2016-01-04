SHELL = bash -o pipefail -c
PATH := $(PATH):$(CURDIR)/bin
export PATH


default :

check :
	@ $(MAKE) -k -C test ; rc=$$? ; $(MAKE) -C test report ; exit $$rc

