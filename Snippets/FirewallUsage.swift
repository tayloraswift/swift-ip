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

let firewall:IP.Firewall = .load(from: try IP.Firewall.Image.init(bson: bson))

guard
let country:ISO.Country = firewall.country[v6: ip]
else
{
    fatalError("No Country found for \(ip)")
}

print("""
    Address: \(ip)
    Country: \(country)
    """)

let (system, _):(IP.AS?, IP.Claimant?) = firewall.lookup(v6: ip)

guard
let system:IP.AS
else
{
    fatalError("No ASN found for \(ip)")
}

print("""
    ASN: \(system.number)
    AS: \(system.domain) (\(system.name))
    """)
