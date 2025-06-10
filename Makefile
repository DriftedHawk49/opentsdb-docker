VERSION ?= 1.0.0

all: build

build:
	docker build -t driftedhawk49/opentsdb-docker-auth:$(VERSION) .

gh-build: HASH=$(shell git rev-parse --short HEAD)
gh-build:
	docker build -t petergrace/opentsdb-docker:$(HASH) .
	docker tag petergrace/opentsdb-docker:$(HASH) petergrace/opentsdb-docker:latest
	docker push petergrace/opentsdb-docker:$(HASH)
	docker push petergrace/opentsdb-docker:latest
