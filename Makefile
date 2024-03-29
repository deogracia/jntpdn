OUTPUT="./output"
SRC=$(shell find . -name "*.go")

.PHONY: all clean ci build build_vanilla build_bsd test check_fmt fmt vet security security_w
.PHONY: lint quality gocyclo goimports

all: clean install_deps quality security test build

# ci*: run tests & build ouput based on runing OS
ci: clean install_deps quality security test build_vanilla
ci_windows: clean install_deps quality security_w test build_vanilla

output:
	$(info ***************** Create "output" directory ***********************************)
	mkdir $(OUTPUT)

clean:
	$(info ***************** Clean ***********************************)
	rm -rf $(OUTPUT)
	go clean -cache -testcache -modcache

security:
	$(info ***************** Security ***********************************)
	gosec ./...
	@echo "[OK] Go security check is done!"

security_w:
	$(info ***************** Security ***********************************)
	gosec "./..."
	@echo "[OK] Go security check is done!"

lint:
	$(info ***************** Lint ***************************************)
	revive -set_exit_status ./...
	@echo "[OK] Go linting is done!"

gocyclo:
	$(info ***************** gocyclo ************************************)
	gocyclo -total-short -over 10 .
	@echo "[OK] gocyclo is done!"

goimports:
	$(info ***************** goimports ***********************************)
	goimports -w ./..
	@echo "[OK] goimpors is done!"

quality: check_fmt vet lint gocyclo

build: output
	make -f build.make all

build_vanilla: output
	make -f build.make build_vanilla

build_bsd: output
	make -f build.make build_bsd

test: check_fmt vet
	$(info ***************** Run tests ***********************************)
	go test -v -count=1  ./...

install_deps:
	$(info ***************** Install dependancies ***********************************)
	go get ./...
	@echo "[OK] Go dependancies is get!"

check_fmt:
	$(info ***************** Check formatting ***********************************)
	test -z $(shell gofmt -l $(SRC)) || (gofmt -d $(SRC); exit 1)
	@echo "[OK] Go code formating"

fmt:
	$(info ***************** Do the formatting ***********************************)
	gofmt -w $(SRC)

vet:
	$(info ***************** Run go vet ***********************************)
	go vet ./...
	@echo "[OK] Go vet is done!"

# vi:syntax=make
