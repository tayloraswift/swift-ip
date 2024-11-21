// swift-tools-version:6.0
import PackageDescription

let package:Package = .init(
    name: "swift-ip",
    platforms: [.macOS(.v15), .iOS(.v18), .tvOS(.v18), .visionOS(.v2), .watchOS(.v11)],
    products: [
        .library(name: "Firewalls", targets: ["Firewalls"]),
        .library(name: "IP", targets: ["IP"]),
        .library(name: "IP_BSON", targets: ["IP_BSON"]),
        .library(name: "IP_NIOCore", targets: ["IP_NIOCore"]),

        .library(name: "IPinfo", targets: ["IPinfo"]),
    ],
    dependencies: [
        .package(url: "https://github.com/tayloraswift/swift-bson", from: "0.1.0"),
        .package(url: "https://github.com/tayloraswift/swift-json", from: "1.1.1"),

        .package(url: "https://github.com/apple/swift-nio", from: "2.75.0"),
    ],
    targets: [
        .target(name: "Firewalls",
            dependencies: [
                .target(name: "IP"),
                .target(name: "IP_BSON"),
                .product(name: "BSON_ISO", package: "swift-bson"),
            ]),

        .target(name: "IP"),

        .target(name: "IP_BSON",
            dependencies: [
                .target(name: "IP"),
                .product(name: "BSON", package: "swift-bson"),
            ]),

        .target(name: "IP_NIOCore",
            dependencies: [
                .target(name: "IP"),
                .product(name: "NIOCore", package: "swift-nio"),
            ]),

        .target(name: "IPinfo",
            dependencies: [
                .target(name: "Firewalls"),
                .product(name: "JSON", package: "swift-json"),
            ]),

        .testTarget(name: "IPTests", dependencies: ["IP"]),
    ])
