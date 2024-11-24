#if canImport(FoundationEssentials)
import FoundationEssentials
#else
import Foundation
#endif

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
        name: [.customLong("country")],
        help: "IPinfo Countries JSON file")
    var country:String

    @Option(
        name: [.customLong("asn")],
        help: "IPinfo Autonomous Systems JSON file")
    var asn:String

    @Option(
        name: [.customLong("output"), .customShort("o")],
        help: "Output BSON file")
    var output:String
}
extension Main
{
    func run() throws
    {
        let autonomousSystems:[IP.AS] = Self.compact(asn: try .splitting(try .init(
                contentsOf: URL.init(fileURLWithPath: self.asn),
                encoding: .utf8),
            where: \.isNewline))

        print("""
            Autonomous System Ranges (IPv4): \(autonomousSystems.reduce(0) { $0 + $1.v4.count })
            Autonomous System Ranges (IPv6): \(autonomousSystems.reduce(0) { $0 + $1.v6.count })
            Autonomous Systems: \(autonomousSystems.count)
            """)

        let countries:[IP.Claims<ISO.Country>] = Self.compact(country: try .splitting(try .init(
                contentsOf: URL.init(fileURLWithPath: self.country),
                encoding: .utf8),
            where: \.isNewline))

        print("""
            Country Ranges (IPv4): \(countries.reduce(0) { $0 + $1.v4.count })
            Country Ranges (IPv6): \(countries.reduce(0) { $0 + $1.v6.count })
            Countries: \(countries.count)
            """)
        for country:IP.Claims<ISO.Country> in countries
        {
            print("    \(country.id): (\(country.v4.count) IPv4, \(country.v6.count) IPv6)")
        }

        var firewall:IP.Firewall = .init(
            autonomousSystems: autonomousSystems,
            countries: countries)

        firewall.attach(
            whitelist: try SearchbotWhitelist.decode(parsing: try .init(
                contentsOf: URL.init(fileURLWithPath: self.googlebot),
                encoding: .utf8)),
            of: .google_common)

        firewall.attach(
            whitelist: try SearchbotWhitelist.decode(parsing: try .init(
                contentsOf: URL.init(fileURLWithPath: self.bingbot),
                encoding: .utf8)),
            of: .microsoft_bingbot)

        firewall.attach(
            whitelist: try GitHubWhitelist.decode(parsing: try .init(
                contentsOf: URL.init(fileURLWithPath: self.github),
                encoding: .utf8)))

        firewall.build()

        let bson:BSON.Document = .init(encoding: firewall)
        try Data.init(bson.bytes).write(to: URL.init(fileURLWithPath: self.output))
    }

    private
    static func compact(country objects:[IPinfo.CountryRange]) -> [IP.Claims<ISO.Country>]
    {
        let table:[ISO.Country: IP.Claims<ISO.Country>] = objects.reduce(into: [:])
        {
            let empty:IP.Claims<ISO.Country> = .init(id: $1.country)

            if  let first:IP.V4 = $1.first.v4,
                let last:IP.V4 = $1.last.v4
            {
                $0[$1.country, default: empty].v4.append(first ... last)
            }
            else
            {
                $0[$1.country, default: empty].v6.append($1.first ... $1.last)
            }
        }

        return table.values.sorted { $0.id < $1.id }
    }

    private
    static func compact(asn objects:[IPinfo.ASNRange]) -> [IP.AS]
    {
        let table:[IP.ASN: IP.AS] = objects.reduce(into: [:])
        {
            let empty:IP.AS = .init(id: $1.asn, domain: $1.domain, name: $1.name)

            if  let first:IP.V4 = $1.first.v4,
                let last:IP.V4 = $1.last.v4
            {
                $0[$1.asn, default: empty].v4.append(first ... last)
            }
            else
            {
                $0[$1.asn, default: empty].v6.append($1.first ... $1.last)
            }
        }

        return table.values.sorted { $0.id < $1.id }
    }
}
