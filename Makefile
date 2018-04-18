RUBBERNECKER_DIR=$(shell pwd)

DOCKER = $(shell command -v docker)

GO     := $(if $(shell which go),go,docker run --rm -v $(RUBBERNECKER_DIR):$(RUBBERNECKER_DIR) -w $(RUBBERNECKER_DIR) golang:1.9 go)
GOLINT := $(if $(shell which golint),golint,$(GO) get -u github.com/golang/lint/golint && golint)
NPM    := $(if $(shell which npm),npm,docker run --rm -v $(RUBBERNECKER_DIR):$(RUBBERNECKER_DIR) -w $(RUBBERNECKER_DIR) node:carbon-alpine npm)

build: scripts styles compile

check_evn:
	$(if $(DOCKER),,$(error "docker not found in PATH"))

compile:
	$(GO) build -o bin/rubbernecker

dependencies:
	$(NPM) install

lint:
	$(GO) fmt ./...
	$(GO) vet ./...
	$(GOLINT) . pkg/...
	$(NPM) run tslint

scripts:
	$(NPM) run tsc

styles:
	$(NPM) run sass

watch:
	$(NPM) run sass:watch

test:
	$(GO) test -v ./...
