# TypoChecker

Typo checker made with swift.
This project is heavily inspired by the [shiba1014/NoMoreTypo](https://github.com/shiba1014/NoMoreTypo), [realm/SwiftLint](https://github.com/realm/SwiftLint)

## Installation
### Makefile
```sh
$ git clone git@github.com:takuchantuyoshi/TypoChecker.git
$ cd TypoChecker
$ make install
```
### [Mint](https://github.com/yonaskolb/Mint)
```sh
$ mint install takuchantuyoshi/TypoChecker
```

## Usage
### Command Line
```sh
$ TypoChecker -directoryPath hoge/foo
```
### Xcode
Integrate TypoChecker into an Xcode scheme to get warnings displayed in the IDE. Just add a new "Run Script Phase" with:
```sh
if which TypoChecker >/dev/null; then
TypoChecker -directoryPath "$SRCROOT" -report xcode
else
echo "warning: TypoChecker not installed, download from https://github.com/takuchantuyoshi/TypoChecker"
fi
```
## Option
You can see options by `TypoChecker --help`

## License
[MIT licensed.](https://github.com/takuchantuyoshi/TypoChecker/blob/master/LICENSE)
