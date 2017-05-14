# octoprint-ios-client [![Build Status](https://travis-ci.com/3DprintFIT/octoprint-ios-client.svg?token=AxpSW7yys3aiQpPG9zMW&branch=dev)](https://travis-ci.com/3DprintFIT/octoprint-ios-client) [![codebeat badge](https://codebeat.co/badges/f2a97050-74db-47c1-a050-daf71d57c7c9)](https://codebeat.co/projects/github-com-3dprintfit-octoprint-ios-client) [![codecov](https://codecov.io/gh/3DprintFIT/octoprint-ios-client/branch/dev/graph/badge.svg)](https://codecov.io/gh/3DprintFIT/octoprint-ios-client)

## Setup

0. Install [Carthage](https://github.com/Carthage/Carthage) dependency manager
1. Install [SwiftLint](https://github.com/realm/SwiftLint) Swift linter
2. Install [SwiftGen](https://github.com/SwiftGen/SwiftGen) which generates translations
3. Run `$ carthage bootstrap --platform iOS`
4. Open `OctoPhone.xcodeproj`
5. :tada:

## Tests

This project also contains tests.
These are located at [OctoPhoneTests](OctoPhoneTests) and are used to test ViewModel layer.
You can run tests in Xcode with `cmd + u` keyboard shortcut.

## Dependencies

This project is build with a huge help of its dependencies:

* [Realm](https://github.com/realm/realm-cocoa)
* [Alamofire](https://github.com/Alamofire/Alamofire)
* [ReactiveSwift](https://github.com/ReactiveCocoa/ReactiveSwift)
* [ReactiveCocoa](https://github.com/ReactiveCocoa/ReactiveCocoa)
* [Moya](https://github.com/Moya/Moya)
* [SnapKit](https://github.com/SnapKit/SnapKit)

github "realm/realm-cocoa" ~> 2.0
github "Alamofire/Alamofire" ~> 4.0
github "ReactiveCocoa/ReactiveSwift" ~> 1.0.1
github "ReactiveCocoa/ReactiveCocoa" ~> 5.0.0
github "Moya/Moya" ~> 8.0.2
github "SnapKit/SnapKit" ~> 3.2.0

## Local usage

### Docker setup

You can run octoprint in docker for testing purposes (on virtual printer). Simply run docker container:

```bash
$ docker run -p"32768:5000" josefdolezal/virtuprint-docker

```

Octoprint now runs on port `32768`.

App should be able to find your docker OctoPrint instance and connect to it.

#### Login

In docker container is test user called `octophone` with `octophone` password. There is pregenerated access token for your app:

```
76DA2D98FFF8447681E1A5C6420B8F4F
```

Now you are set up. OctoPhone is now available to control virtual printer.
