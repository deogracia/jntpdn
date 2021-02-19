SHELL=/bin/bash
OUTPUT=./output
CMD_OUTPUTS=./jntpdn-docs
GO_STUFF=$(wildcard coverage.*)
SRC=$(shell find . -name "*.go")

.PHONY: all clean ci build build_vanilla build_bsd test check_fmt fmt vet security security_w
.PHONY: lint quality gocyclo goimports formatcode
.PHONY: format_and_test

# Default task, since it's the first one
all: clean install_deps quality security test build

## Global targets

# ci*: run tests & build ouput based on runing OS
ci: clean install_deps quality security test build_vanilla
ci_windows: clean install_deps quality security_w test build_vanilla

quality: check_fmt vet lint gocyclo

formatcode: goimports fmt
	@echo "[OK] formatcode is done!"

format_and_test: formatcode test

test: check_fmt vet
	$(call print-target)
	$(info ***************** Run tests ***********************************)
	go test -race -covermode=atomic -coverprofile=coverage.out -v -count=1  ./...
	go tool cover -html=coverage.out -o coverage.html

## Specific / unitary targets
output: ## Create "output" directory
	$(call print-target)
	$(info ***************** Create "output" directory ***********************************)
	mkdir $(OUTPUT)

clean: ## Clean it up!
	$(call print-target)
	$(info ***************** Clean ***********************************)
	rm -rf $(OUTPUT) $(CMD_OUTPUTS) ${GO_STUFF}
	go clean -cache -testcache -modcache

security: ## Run gosec
	$(call print-target)
	$(info ***************** Security ***********************************)
	gosec ./...
	@echo "[OK] Go security check is done!"

security_w: ## Run gosec on windows
	$(call print-target)
	$(info ***************** Security ***********************************)
	gosec "./..."
	@echo "[OK] Go security check is done!"

lint: ## Run go lint
	$(call print-target)
	$(info ***************** Lint ***************************************)
	golint -set_exit_status ./...
	@echo "[OK] Go linting is done!"

gocyclo: ## Run gocyclo
	$(call print-target)
	$(info ***************** gocyclo ************************************)
	gocyclo -total -avg -over 10 .
	@echo "[OK] gocyclo is done!"

goimports: ## Run goimports
	$(call print-target)
	$(info ***************** goimports ***********************************)
	goimports -w ./..
	@echo "[OK] goimpors is done!"

build: output
	make -f build.make all

build_vanilla: output
	make -f build.make build_vanilla

build_bsd: output
	make -f build.make build_bsd

install_deps: ## install go dependancies
	$(call print-target)
	$(info ***************** Install dependancies ***********************************)
	go get ./...
	@echo "[OK] Go dependancies is get!"

check_fmt: ## Check go code's format
	$(call print-target)
	$(info ***************** Check formatting ***********************************)
	test -z $(shell gofmt -l $(SRC)) || (gofmt -d $(SRC); exit 1)
	@echo "[OK] Go code formating"

fmt: ## Format go code
	$(call print-target)
	$(info ***************** Do the formatting ***********************************)
	gofmt -w $(SRC)

vet: ## Run go get
	$(call print-target)
	$(info ***************** Run go vet ***********************************)
	go vet ./...
	@echo "[OK] Go vet is done!"

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'


## functions

define print-target
	@printf "***************** Executing target: \033[36m$@\033[0m\n"
endef
# vi:syntax=make
