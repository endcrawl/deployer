SHELL = bash -o pipefail -c
PATH := $(CURDIR)/../bin:$(CURDIR)/bin:$(PATH)
export PATH

TEST_CASES   = $(shell find case -type f | sort)
TEST_OUTPUTS = ${TEST_CASES:case/%=out/%}


default : tests

tests : clean $(TEST_OUTPUTS)

clean :
	@ rm -rf out/* work/* pass/* fail/*

out/% : case/%
	@ printf "[test] %-40s ... " $*
	@ if env - PATH="$$PATH" $^ "$(CURDIR)"/work/$* >$@ 2>&1; then \
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

