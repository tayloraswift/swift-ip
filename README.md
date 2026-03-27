<div align="center">

📍 &nbsp; **swift-ip** &nbsp; 📍

exchange strongly-typed values with zero overhead without falling back to raw integer representations or linking against large frameworks!

[documentation](https://swiftinit.org/docs/swift-ip) ·
[license](LICENSE)

</div>


## Requirements

The swift-ip library is a portable, Foundation-free library for working with IP addresses. It provides tools for parsing and formatting IP addresses, data structures for performing efficient IP address lookups, and shims for compatibility with types from other libraries such as SwiftNIO.

The swift-ip library requires Swift 6.0 or later. This is because [`IP.V6`](https://swiftinit.org/docs/swift-ip/ip/ip/v6) uses [`UInt128`](https://swiftinit.org/docs/swift/swift/uint128).

<!-- DO NOT EDIT BELOW! AUTOSYNC CONTENT [STATUS TABLE] -->
| Platform | Status |
| -------- | ------|
| 💬 Documentation | [![Status](https://raw.githubusercontent.com/rarestype/swift-ip/refs/badges/ci/Documentation/_all/status.svg)](https://github.com/rarestype/swift-ip/actions/workflows/Documentation.yml) |
| 💝 Release | [![Status](https://raw.githubusercontent.com/rarestype/swift-ip/refs/badges/ci/Release/Linux-aarch64/status.svg)](https://github.com/rarestype/swift-ip/actions/workflows/Release.yml) |
| 🗝 Update | [![Status](https://raw.githubusercontent.com/rarestype/swift-ip/refs/badges/ci/Update/Firewall/status.svg)](https://github.com/rarestype/swift-ip/actions/workflows/Update.yml) |
| 🐧 Linux | [![Status](https://raw.githubusercontent.com/rarestype/swift-ip/refs/badges/ci/Tests/Linux/status.svg)](https://github.com/rarestype/swift-ip/actions/workflows/Tests.yml) |
| 🍏 Darwin | [![Status](https://raw.githubusercontent.com/rarestype/swift-ip/refs/badges/ci/Tests/macOS/status.svg)](https://github.com/rarestype/swift-ip/actions/workflows/Tests.yml) |
| 🍏 Darwin (iOS) | [![Status](https://raw.githubusercontent.com/rarestype/swift-ip/refs/badges/ci/Tests/iOS/status.svg)](https://github.com/rarestype/swift-ip/actions/workflows/Tests.yml) |
| 🍏 Darwin (tvOS) | [![Status](https://raw.githubusercontent.com/rarestype/swift-ip/refs/badges/ci/Tests/tvOS/status.svg)](https://github.com/rarestype/swift-ip/actions/workflows/Tests.yml) |
| 🍏 Darwin (visionOS) | [![Status](https://raw.githubusercontent.com/rarestype/swift-ip/refs/badges/ci/Tests/visionOS/status.svg)](https://github.com/rarestype/swift-ip/actions/workflows/Tests.yml) |
| 🍏 Darwin (watchOS) | [![Status](https://raw.githubusercontent.com/rarestype/swift-ip/refs/badges/ci/Tests/watchOS/status.svg)](https://github.com/rarestype/swift-ip/actions/workflows/Tests.yml) |
<!-- DO NOT EDIT ABOVE! AUTOSYNC CONTENT [STATUS TABLE] -->

[Check deployment minimums](https://swiftinit.org/docs/swift-ip#ss:platform-requirements)


## Why use swift-ip?

The IP address types defined by the `Network` framework are Darwin-only, which precludes their use in server-side code.

The swift-nio library provides a multi-platform [`SocketAddress`](https://swiftinit.org/docs/swift-nio/niocore/socketaddress) type, but it is heap-allocated and reference-counted, and requires linking against the entire `NIOCore` module. This makes it unsuitable as a high-performance currency type for purposes such as firewall implementations or metrics collection.


## Who is using swift-ip?

The [Swiftinit](https://swiftinit.org) documentation index currently uses the swift-ip library to verify clients such as Googlebot and GitHub Webhooks.


## License

The swift-ip library is Apache 2.0 licensed.
