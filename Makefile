.DEFAULT_GOAL := build
src = $(shell find src/ -type f -name '*.cr')
specs = $(shell find spec/ -type f -name '*.cr')

.PHONY: build
build: $(src)
	@mkdir -p bin
	crystal build src/tmdb.cr -o bin/tmdb

release:
	@mkdir -p bin
	crystal build --release src/tmdb.cr -o bin/tmdb

test:
	@if [ -n "$(shell ps -x -o command= $$PPID | grep '^vim')" ]; then crystal spec --no-color; else crystal spec; fi

.PHONY: spec
spec: test

bin/run_tests: $(src) $(specs)
	@crystal build spec/run_tests.cr -o bin/run_tests

.PHONY: coverage
coverage: bin/run_tests
	@kcov --clean --verify --include-path=$(shell pwd)/src $(shell pwd)/coverage ./bin/run_tests

.PHONY: cov
cov: coverage

help: ## Prints this help.
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN ; '
