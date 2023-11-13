.POSIX:

ROOTDIR  = $$PWD

all:
	@if [ ! -d build ]; then \
		mkdir build;     \
	fi
	@cd build; voc -s ${ROOTDIR}/../src/strTypes.Mod      \
			  ${ROOTDIR}/../src/strUtils.Mod

test:
	@if [ ! -d build ]; then      \
		echo Run make, first; \
		exit 1;               \
	fi
	@cd build && voc ${ROOTDIR}/../test/testStrUtils.Mod -m          \
		       > /dev/null 2>&1                               \
		       || (echo Failed to compile, have you run make? \
		           && exit 1)
	@./build/testStrUtils                                 \
		> /dev/null 2>81                              \
		&& echo ${ROOTDIR}/build/testStrUtils: passed \
		|| echo ${ROOTDIR}/build/testStrUtils: failed

clean:
	rm -rf build

.PHONY: test
