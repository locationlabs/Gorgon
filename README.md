# Medusa

[![Build Status](https://travis-ci.org/locationlabs/Medusa.svg?branch=master)](https://travis-ci.org/locationlabs/Medusa)

Medusa is lightweight abstraction for distributing the responsibility of the
`UIApplicationDelegate` into several [single responsibility][1] daemons.

In operating system computing, a daemon is a process that runs in the background rather than being
controlled by the user. Medusa borrows from this concept to break up the UIApplicationDelegate
that responds to the UIApplication singleton events into daemons which are started when the application
starts (therefore exist for the life of the application) and wait to be triggered by the `DaemonManager`.
The user never interacts with the daemons directly.

## Features
- [X] Breaks up `UIApplicationDelegate` across several [single responsibility][1] classes.
- [X] Handles delegation of system application events to respective daemon types.

Medusa works best when used with [Cobra][2], an application routing framework written in Swift
and [Mocassin][3], Xcode templates that provides a variation of [VIPER][4] architecture for iOS
applications.

See [Boa][5], a sample app written in Swift, for details.

## Requirements
- iOS 8+
- Swift 2.2
	- Xcode 7.3+

## Installation
Medusa is available through [CocoaPods](https://cocoapods.org).

### CocoaPods

To install Medusa with CocoaPods, add the following lines to your `Podfile`.

    source 'https://github.com/CocoaPods/Specs.git'
    platform :ios, '8.0'
    use_frameworks!

    pod 'Hydra', '~> 1.0'

Then run `pod install` command. For details of the installation and usage of CocoaPods, visit [its official website](https://cocoapods.org).

### Carthage

To install Medusa with Carthage, add the following line to your `Cartfile`.

```
github "locationlabs/Hydra" ~> 1.1
```

Then run `carthage update`. For details of the installation and usage of Carthage, visit [its project page](https://github.com/Carthage/Carthage).

## Documentation
WIP

## TODO
This is the initial port of an internal framework developed at [Location Labs][6] for building
modular iOS applications. Be it that this library used to be used internally there are things
that haven't been implemented yet...

- [ ] Documentation
- [ ] Installation guide
- [ ] More unit tests
- [ ] Swift Package Manager support
- [ ] TvOS, WatchOS, MacOS support
- [ ] Swiftlint support
- [ ] Provide contribution guidelines

[1]: https://en.wikipedia.org/wiki/Single_responsibility_principle
[2]: https://github.com/locationlabs/Cobra
[3]: https://github.com/locationlabs/Moccasin
[4]: http://mutualmobile.github.io/blog/2013/12/04/viper-introduction/
[5]: https://github.com/locationlabs/Boa
[6]: http://www.locationlabs.com/
