XC_OS="linux windows freebsd"
XC_ARCH="amd64 386"
XC_OS_BSD="freebsd"
XC_DARWIN="darwin"
XC_DARWIN_ARCH="amd64"
XC_PARALLEL="2"
OUTPUT="./output"
NAME="jntpdn"
SRC=$(shell find . -name "*.go")

ifeq (, $(shell which gox))
$(warning "could not find gox in $(PATH), run: go get github.com/mitchellh/gox")
endif

.PHONY: all build build_vanilla build_bsd

all: build
	@echo "[OK] Build done!"

build:
	$(info ***************** Build the artefacts ***********************************)

	mkdir -p ${OUTPUT}
	gox \
		-os=$(XC_OS) \
		-arch=$(XC_ARCH) \
		-parallel=$(XC_PARALLEL) \
		-output=$(OUTPUT)/$(NAME)_{{.OS}}_{{.Arch}} \
		github.com/deogracia/jntpdn/cmd/jntpdn \
		;

	gox \
		-os=$(XC_DARWIN) \
		-arch=$(XC_DARWIN_ARCH) \
		-parallel=$(XC_PARALLEL) \
		-output=$(OUTPUT)/$(NAME)_{{.OS}}_{{.Arch}} \
		github.com/deogracia/jntpdn/cmd/jntpdn \
		;

build_vanilla:
	$(info ***************** Build the artefacts for the current OS & ARCH *********)

	mkdir -p ${OUTPUT}
	go build -o $(OUTPUT)/$(NAME)_test github.com/deogracia/jntpdn/cmd/jntpdn

build_bsd:
	$(info ***************** Cross Build the artefacts for *BSD ********************)

	mkdir -p ${OUTPUT}
	gox \
		-os=$(XC_OS_BSD) \
		-arch=$(XC_ARCH) \
		-parallel=$(XC_PARALLEL) \
		-output=$(OUTPUT)/$(NAME)_{{.OS}}_{{.Arch}} \
		github.com/deogracia/jntpdn/cmd/jntpdn \
		;

# vi:syntax=make
