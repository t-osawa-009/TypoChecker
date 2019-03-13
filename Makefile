BINARY?=TypoChecker
PROJECT?=TypoChecker
BUILD_FOLDER?=.build
PREFIX?=/usr/local
RELEASE_BINARY_FOLDER?=$(BUILD_FOLDER)/release/$(PROJECT)

xcode:
	swift package generate-xcodeproj

update:
	swift package update

build:
	swift build -c release -Xswiftc -static-stdlib

install: update build
	mkdir -p $(PREFIX)/bin
	cp -f $(RELEASE_BINARY_FOLDER) $(PREFIX)/bin/$(BINARY)

uninstall:
	rm -f $(PREFIX)/bin/$(BINARY)