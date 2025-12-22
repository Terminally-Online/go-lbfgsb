.PHONY: all clean build-darwin-arm64 build-darwin-amd64 build-linux-amd64

UNAME_S := $(shell uname -s)
UNAME_M := $(shell uname -m)

all:
ifeq ($(UNAME_S),Darwin)
ifeq ($(UNAME_M),arm64)
	$(MAKE) build-darwin-arm64
else
	$(MAKE) build-darwin-amd64
endif
else
	$(MAKE) build-linux-amd64
endif

build-darwin-arm64:
	@echo "Building for darwin/arm64..."
	cd src && gfortran -c -O2 -fPIC lbfgsb.f blas.f linpack.f timer.f
	cd src && gfortran -c -O2 -fPIC lbfgsb__entry.f90
	cd src && gfortran -c -O2 -fPIC lbfgsb_c.f90
	ld -r -o lbfgsb_darwin_arm64.syso \
		src/lbfgsb.o src/blas.o src/linpack.o src/timer.o \
		src/lbfgsb__entry.o src/lbfgsb_c.o \
		$$(brew --prefix gcc)/lib/gcc/current/libgfortran.a \
		$$(brew --prefix gcc)/lib/gcc/current/libquadmath.a \
		$$(brew --prefix gcc)/lib/gcc/current/gcc/aarch64-apple-darwin*/*/libgcc.a
	rm -f src/*.o src/*.mod
	@echo "Built lbfgsb_darwin_arm64.syso"

build-darwin-amd64:
	@echo "Building for darwin/amd64..."
	cd src && gfortran -c -O2 -fPIC lbfgsb.f blas.f linpack.f timer.f
	cd src && gfortran -c -O2 -fPIC lbfgsb__entry.f90
	cd src && gfortran -c -O2 -fPIC lbfgsb_c.f90
	ld -r -o lbfgsb_darwin_amd64.syso \
		src/lbfgsb.o src/blas.o src/linpack.o src/timer.o \
		src/lbfgsb__entry.o src/lbfgsb_c.o \
		$$(brew --prefix gcc)/lib/gcc/current/libgfortran.a \
		$$(brew --prefix gcc)/lib/gcc/current/libquadmath.a \
		$$(brew --prefix gcc)/lib/gcc/current/gcc/x86_64-apple-darwin*/*/libgcc.a
	rm -f src/*.o src/*.mod
	@echo "Built lbfgsb_darwin_amd64.syso"

build-linux-amd64:
	@echo "Building for linux/amd64..."
	cd src && gfortran -c -O2 -fPIC lbfgsb.f blas.f linpack.f timer.f
	cd src && gfortran -c -O2 -fPIC lbfgsb__entry.f90
	cd src && gfortran -c -O2 -fPIC lbfgsb_c.f90
	ld -r -o lbfgsb_linux_amd64.syso \
		src/lbfgsb.o src/blas.o src/linpack.o src/timer.o \
		src/lbfgsb__entry.o src/lbfgsb_c.o \
		/usr/lib/x86_64-linux-gnu/libgfortran.a \
		/usr/lib/x86_64-linux-gnu/libquadmath.a \
		/usr/lib/gcc/x86_64-linux-gnu/*/libgcc.a
	rm -f src/*.o src/*.mod
	@echo "Built lbfgsb_linux_amd64.syso"

clean:
	rm -f src/*.o src/*.mod *.syso
