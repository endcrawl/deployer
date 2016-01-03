default :

check : tests

TESTS_IN  = $(shell find tests -type f )
TESTS_OUT = ${TESTS_IN:tests/%=tests.out/%}

tests : $(TESTS_OUT)

tests.out/% : tests/%
	@ mkdir -p tests.out
	@ printf "[test] %s ... " "$*"
	@ $^ >$@ 2>&1
	@ printf "pass\n"

