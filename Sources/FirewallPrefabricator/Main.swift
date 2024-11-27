#if canImport(FoundationEssentials)
import FoundationEssentials
#else
import Foundation
#endif

// $ docker run --rm -it -p 8443:8443 --network=unidoc-test --memory 20m -v ~/swift:/swift -e LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libjemalloc.so.2 -w /swift/swiftinit tayloraswift/ubuntu:latest /bin/bash

import ArgumentParser
import BSON
import Firewalls
import IP
import IPinfo
import ISO
import Whitelists

@main
struct Main:ParsableCommand
{
    @Option(
        name: [.customLong("googlebot")],
        help: "Googlebot JSON file")
    var googlebot:String

    @Option(
        name: [.customLong("bingbot")],
        help: "Bingbot JSON file")
    var bingbot:String

    @Option(
        name: [.customLong("github")],
        help: "GitHub Metadata JSON file")
    var github:String

    @Option(
        name: [.customLong("ipinfo")],
        help: "IPinfo JSON file")
    var ipinfo:String

    @Option(
        name: [.customLong("output"), .customShort("o")],
        help: "Output BSON file")
    var output:String
}
extension Main
{
    func run() throws
    {
        var image:IP.Firewall.Image = try .build(from: try .splitting(try .init(
                contentsOf: URL.init(fileURLWithPath: self.ipinfo),
                encoding: .utf8),
            where: \.isNewline))

        let googlebot:SearchbotWhitelist = try .decode(parsing: try .init(
            contentsOf: URL.init(fileURLWithPath: self.googlebot),
            encoding: .utf8))

        let bingbot:SearchbotWhitelist = try .decode(parsing: try .init(
            contentsOf: URL.init(fileURLWithPath: self.bingbot),
            encoding: .utf8))

        let github:GitHubWhitelist = try .decode(parsing: try .init(
            contentsOf: URL.init(fileURLWithPath: self.github),
            encoding: .utf8))

        var claims:[IP.Claims] = []

        googlebot.add(to: &claims, as: .google_common)
        bingbot.add(to: &claims, as: .microsoft_bingbot)
        github.add(to: &claims)

        try image.claim(claims)

        let bson:BSON.Document = .init(encoding: image)
        try Data.init(bson.bytes).write(to: URL.init(fileURLWithPath: self.output))
    }
}
