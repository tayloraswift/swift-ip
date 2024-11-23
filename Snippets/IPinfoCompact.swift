#if canImport(FoundationEssentials)
import FoundationEssentials
#else
import Foundation
#endif

import BSON
import Firewalls
import JSON
import IP
import IP_BSON
import IPinfo
import ISO

if  CommandLine.arguments.count == 3
{
    let argument:(input:String, output:String) =
    (
        CommandLine.arguments[1],
        CommandLine.arguments[2]
    )

    let input:String = try .init(
        contentsOf: URL.init(fileURLWithPath: argument.input),
        encoding: .utf8)

    let bson:BSON.List

    do
    {
        bson = compact(asn: try .splitting(input, where: \.isNewline))
    }
    catch
    {
        bson = compact(country: try .splitting(input, where: \.isNewline))
    }

    try Data.init(bson.bytes).write(to: URL.init(fileURLWithPath: argument.output))
}
else
{
    print("Usage: \(CommandLine.arguments[0]) <input.json> <output.bson>")
}

func compact(country objects:[IPinfo.CountryRange]) -> BSON.List
{
    let table:[ISO.Country: IP.Country] = objects.reduce(into: [:])
    {
        let empty:IP.Country = .init(id: $1.country)

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

    var list:[IP.Country] = table.values.sorted { $0.id < $1.id }

    for i:Int in list.indices
    {
        list[i].v4.sort { $0.lowerBound < $1.lowerBound }
        list[i].v6.sort { $0.lowerBound < $1.lowerBound }
    }

    print("""
        Country Ranges (IPv4): \(list.reduce(0) { $0 + $1.v4.count })
        Country Ranges (IPv6): \(list.reduce(0) { $0 + $1.v6.count })
        Countries: \(list.count)
        """)
    for country:IP.Country in list
    {
        print("    \(country.id): (\(country.v4.count) IPv4, \(country.v6.count) IPv6)")
    }

    return .init(elements: list)
}
func compact(asn objects:[IPinfo.ASNRange]) -> BSON.List
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

    var list:[IP.AS] = table.values.sorted { $0.id < $1.id }
    for i:Int in list.indices
    {
        list[i].v4.sort { $0.lowerBound < $1.lowerBound }
        list[i].v6.sort { $0.lowerBound < $1.lowerBound }
    }

    print("""
        Autonomous System Ranges (IPv4): \(list.reduce(0) { $0 + $1.v4.count })
        Autonomous System Ranges (IPv6): \(list.reduce(0) { $0 + $1.v6.count })
        Autonomous Systems: \(list.count)
        """)

    return .init(elements: list)
}

extension Array where Element:JSONDecodable
{
    static func splitting(_ file:String, where delimiter:(Character) -> Bool) throws -> Self
    {
        var i:String.Index = file.startIndex
        var elements:Self = []

        while let j:String.Index = file[i...].firstIndex(where: delimiter)
        {
            let json:JSON = .init(utf8: [UInt8].init(file[i ..< j].utf8)[...])
            elements.append(try json.decode())
            i = file.index(after: j)
        }
        if  i != file.endIndex
        {
            // JSON is missing trailing newline
            let json:JSON = .init(utf8: [UInt8].init(file[i...].utf8)[...])
            elements.append(try json.decode())
        }

        return elements
    }
}
