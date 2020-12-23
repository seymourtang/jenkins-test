NAME := jenkins-test
ROOT := github.com/seymourtang/jenkins-test
VERSION ?= $(shell git describe --tags --always --dirty)
COMMIT = $(shell git rev-parse HEAD)
BRANCH = $(shell git branch | grep \* | cut -d ' ' -f2)
BUILD_DATE = $(shell date -u +'%Y-%m-%dT%H:%M:%SZ')


# It's necessary to set the errexit flags for the bash shell.
export SHELLOPTS := errexit

# This will force go to use the vendor files instead of using the `$GOPATH/pkg/mod`. (vendor mode)
# more info: https://github.com/golang/go/wiki/Modules#how-do-i-use-vendoring-with-modules-is-vendoring-going-away
export GOFLAGS := -mod=vendor

# this is not a public registry; change it to your own
REGISTRY ?= seymourtang/
BASE_REGISTRY ?=

ARCH ?=
GO_VERSION ?= 1.15

CPUS ?= $(shell /bin/bash hack/read_cpus_available.sh)

# Track code version with Docker Label.
DOCKER_LABELS ?= git-describe="$(shell date -u +v%Y%m%d)-$(shell git describe --tags --always --dirty)"

GOPATH ?= $(shell go env GOPATH)
BIN_DIR := $(GOPATH)/bin
GOLANGCI_LINT := $(BIN_DIR)/golangci-lint
CMD_DIR := ./cmd
OUTPUT_DIR := ./bin
BUILD_DIR := ./build

.PHONY: lint test build build-local build-linux container push clean

build: build-local

build-local: clean
	@echo ">> building binaries"``
	@GOOS=$(shell uname -s | tr A-Z a-z) GOARCH=$(ARCH) CGO_ENABLED=0	 \
	go build -i -v -o $(OUTPUT_DIR)/$(NAME) -p $(CPUS)			\
		 -ldflags "-s -w"					 							\
	 $(CMD_DIR)/

build-linux:
	@docker run --rm -t                                                                \
	  -v $(PWD):/go/src/$(ROOT)                                                        \
	  -w /go/src/$(ROOT)                                                               \
	  -e GOOS=linux                                                                    \
	  -e GOARCH=amd64                                                                  \
	  -e GOPATH=/go                                                                    \
	  -e CGO_ENABLED=0																    \
	  -e GOFLAGS=$(GOFLAGS)   	                                                       \
	  -e SHELLOPTS=$(SHELLOPTS)                                                        \
	  $(BASE_REGISTRY)golang:$(GO_VERSION)                                            \
	    /bin/bash -c '                                    								\
	      	go build -i -v -o $(OUTPUT_DIR)/$(NAME) -p $(CPUS)					\
          		 -ldflags "-s -w"					 								\
          	 $(CMD_DIR)/'                                                    			\

container: build-linux
	@echo ">> building image"
	@docker build -t $(REGISTRY)$(NAME):$(VERSION) --label $(DOCKER_LABELS)  -f $(BUILD_DIR)/Dockerfile .

push: container
	@echo ">> pushing image"
	@docker push $(REGISTRY)$(NAME):$(VERSION)

lint: $(GOLANGCI_LINT)
	@echo ">> running golangci-lint"
	@$(GOLANGCI_LINT) run

$(GOLANGCI_LINT):
	@curl -sfL https://install.goreleaser.com/github.com/golangci/golangci-lint.sh | sh -s -- -b $(BIN_DIR) v1.33.0

test:
	@echo ">> running tests"
	@go test -p $(CPUS) $$(go list ./... | grep -v /vendor) -coverprofile=coverage.out
	@go tool cover -func coverage.out | tail -n 1 | awk '{ print "Total coverage: " $$3 }'

clean:
	@echo ">> cleaning up"
	@-rm -vrf ${OUTPUT_DIR}
	@rm -f coverage.out