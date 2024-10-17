<div align="center">

***`ip`***

[![Tests](https://github.com/tayloraswift/swift-ip/actions/workflows/Tests.yml/badge.svg)](https://github.com/tayloraswift/swift-ip/actions/workflows/Tests.yml)
[![Documentation](https://github.com/tayloraswift/swift-ip/actions/workflows/Documentation.yml/badge.svg)](https://github.com/tayloraswift/swift-ip/actions/workflows/Documentation.yml)

</div>

The ***swift-ip*** library is a portable, Foundation-free library for working with IP addresses. It provides tools for parsing and formatting IP addresses, data structures for performing efficient IP address lookups, and shims for compatibility with types from other libraries such as SwiftNIO.

One of the goals of this library is to allow other libraries to exchange strongly-typed values with zero overhead without falling back to raw integer representations or linking against large frameworks.

<div align="center">

[documentation](https://swiftinit.org/docs/swift-ip/ip) ·
[license](LICENSE)

</div>


## Requirements

The swift-ip library requires Swift 6.0 or later. This is because [`IP.V6`](https://swiftinit.org/docs/swift-ip/ip/ip/v6) uses [`UInt128`](https://swiftinit.org/docs/swift/swift/uint128).


| Platform | Status |
| -------- | ------ |
| 🐧 Linux | [![Tests](https://github.com/tayloraswift/swift-ip/actions/workflows/Tests.yml/badge.svg)](https://github.com/tayloraswift/swift-ip/actions/workflows/Tests.yml) |
| 🍏 Darwin | [![Tests](https://github.com/tayloraswift/swift-ip/actions/workflows/Tests.yml/badge.svg)](https://github.com/tayloraswift/swift-ip/actions/workflows/Tests.yml) |
| 🍏 Darwin (iOS) | [![iOS](https://github.com/tayloraswift/swift-ip/actions/workflows/iOS.yml/badge.svg)](https://github.com/tayloraswift/swift-ip/actions/workflows/iOS.yml) |
| 🍏 Darwin (tvOS) | [![tvOS](https://github.com/tayloraswift/swift-ip/actions/workflows/tvOS.yml/badge.svg)](https://github.com/tayloraswift/swift-ip/actions/workflows/tvOS.yml) |
| 🍏 Darwin (visionOS) | [![visionOS](https://github.com/tayloraswift/swift-ip/actions/workflows/visionOS.yml/badge.svg)](https://github.com/tayloraswift/swift-ip/actions/workflows/visionOS.yml) |
| 🍏 Darwin (watchOS) | [![watchOS](https://github.com/tayloraswift/swift-ip/actions/workflows/watchOS.yml/badge.svg)](https://github.com/tayloraswift/swift-ip/actions/workflows/watchOS.yml) |


[Check deployment minimums](https://swiftinit.org/docs/swift-ip#ss:platform-requirements)


## Why use swift-ip?

The IP address types defined by the `Network` framework are Darwin-only, which precludes their use in server-side code.

The swift-nio library provides a multi-platform [`SocketAddress`](https://swiftinit.org/docs/swift-nio/niocore/socketaddress) type, but it is heap-allocated and reference-counted, and requires linking against the entire `NIOCore` module. This makes it unsuitable as a high-performance currency type for purposes such as firewall implementations or metrics collection.


## Who is using swift-ip?

The [Swiftinit](https://swiftinit.org) documentation index currently uses the swift-ip library to verify clients (such as Googlebot and GitHub Webhooks) and combat abuse.


## License

The swift-ip library is Apache 2.0 licensed.
