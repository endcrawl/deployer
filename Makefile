SHELL = bash -o pipefail -c
PATH := $(PATH):$(CURDIR)/bin
export PATH


default :

check : tests

TEST_CASES   = $(shell find test/case -type f | sort)
TEST_OUTPUTS = ${TEST_CASES:test/case/%=test/out/%}

tests : $(TEST_OUTPUTS)

test/out/% : test/case/%
	@ printf "[test] %s ... " $*
	@ $^ "$(CURDIR)"/test/work/$* >$@ 2>&1
	@ printf "pass\n"

