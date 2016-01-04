TEST_CASES   = $(shell find case -type f | sort)
TEST_OUTPUTS = ${TEST_CASES:case/%=out/%}


default : $(TEST_OUTPUTS)

out/% : case/%
	@ printf "[test] %s ... " $*
	@ $^ "$(CURDIR)"/work/$* >$@ 2>&1
	@ printf "pass\n"

