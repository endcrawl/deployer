TEST_CASES   = $(shell find case -type f | sort)
TEST_OUTPUTS = ${TEST_CASES:case/%=out/%}


default : $(TEST_OUTPUTS)

out/% : case/%
	@ printf "[test] %-32s ... " $*
	@ rm -f pass/$*
	@ rm -f fail/$*
	@ if $^ "$(CURDIR)"/work/$* >$@ 2>&1; then \
	    printf "pass\n" ; \
	    touch pass/$* ; \
	  else \
	    rc=$$? ; \
	    printf "fail\n" ; \
	    touch fail/$* ; \
	    exit $$rc ; \
	  fi

report :
	@ printf "[test results] %d/%d passing\n" \
	  `find pass -type f -not -name \*.empty | wc -l` \
	  `find case -type f | wc -l`

