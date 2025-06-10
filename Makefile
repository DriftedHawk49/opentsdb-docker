VERSION ?= latest

all: build

build:
	docker build -t driftedhawk49/opentsdb-docker:$(VERSION) .
