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
let (mapping, claimant):(IP.Mapping?, IP.Claimant?) = firewall.lookup(v6: ip)

guard
let mapping:IP.Mapping
else
{
    fatalError("No Country/ASN found for \(ip)")
}

print("""
    Address: \(ip)
    Country: \(mapping.country)
    """)

if  let autonomousSystem:IP.AS = mapping.autonomousSystem
{
    print("""
        ASN: \(autonomousSystem.number)
        AS: \(autonomousSystem.domain) (\(autonomousSystem.name))
        """)
}
