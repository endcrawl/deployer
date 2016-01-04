TEST_CASES   = $(shell find case -type f | sort)
TEST_OUTPUTS = ${TEST_CASES:case/%=out/%}


default : $(TEST_OUTPUTS)

out/% : case/%
	@ printf "[test] %s ... " $*
	@ rm -f {pass,fail}/$*
	@ if $^ "$(CURDIR)"/work/$* >$@ 2>&1; then \
	    printf "pass\n" ; \
	    touch pass/$* ; \
	  else \
	    rc=$$? ; \
	    printf "fail\n" ; \
	    touch fail/$* ; \
	    exit $$rc ; \
	  fi

