#if canImport(FoundationEssentials)
import FoundationEssentials
#else
import Foundation
#endif

import BSON
import Firewalls
import IP
import ISO

guard CommandLine.arguments.count == 2
else
{
    fatalError("Usage: \(CommandLine.arguments[0]) <ip address>")
}

let ip:IP.V6

if  let ipv4:IP.V4 = .init(CommandLine.arguments[1])
{
    ip = .init(v4: ipv4)
}
else if let ipv6:IP.V6 = .init(CommandLine.arguments[1])
{
    ip = ipv6
}
else
{
    fatalError("Invalid IP address")
}

let data:Data = try .init(contentsOf: URL.init(fileURLWithPath: "firewall.bson"))
let bson:BSON.Document = .init(bytes: [UInt8].init(data)[...])

let firewall:IP.Firewall = try .init(bson: bson)
let mappings:IP.Mappings = try .load(from: firewall)


guard
let country:ISO.Country = mappings.countries[v6: ip],
let asn:IP.ASN = mappings.autonomousSystems[v6: ip]
else
{
    fatalError("No Country/ASN found for \(ip)")
}

guard
let metadata:IP.AS.Metadata = mappings.autonomousSystemMetadata[asn]
else
{
    fatalError("No AS metadata found for \(asn)")
}

print("""
    Address: \(ip)
    Country: \(country)
    ASN: \(asn)
    AS: \(metadata.domain) (\(metadata.name))
    """)
