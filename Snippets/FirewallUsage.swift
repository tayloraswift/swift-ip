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

//  snippet.LOAD_FIREWALL
let data:Data = try .init(contentsOf: URL.init(fileURLWithPath: "firewall.bson"))
let bson:BSON.Document = .init(bytes: [UInt8].init(data)[...])

let firewall:IP.Firewall = .load(from: try IP.Firewall.Image.init(bson: bson))

//  snippet.LOOKUP_COUNTRY
let country:ISO.Country? = firewall.country[v6: ip]
//  snippet.end
if  let country:ISO.Country
{
    print("Country: \(country)")
}

//  snippet.LOOKUP_ASN
let (system, claimant):(IP.AS?, IP.Claimant?) = firewall.lookup(v6: ip)
//  snippet.end
if  let system:IP.AS
{
    print("""
        ASN: \(system.number)
        AS: \(system.domain) (\(system.name))
        """)
}

if  let claimant:IP.Claimant
{
    print("""
        Claimant: \(claimant)
        """)
}
