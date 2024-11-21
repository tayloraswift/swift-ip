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
        $0[$1.country, default: empty].ranges.append($1.first ... $1.last)
    }

    print("""
        Country Ranges: \(table.values.reduce(0) { $0 + $1.ranges.count })
        Countries: \(table.count)
        """)
    for (id, country):(ISO.Country, IP.Country) in table.sorted(by: { $0.key < $1.key })
    {
        print("    \(id): \(country.ranges.count)")
    }

    return .init(elements: table.values.sorted { $0.id < $1.id })
}
func compact(asn objects:[IPinfo.ASNRange]) -> BSON.List
{
    let table:[IP.ASN: IP.AS] = objects.reduce(into: [:])
    {
        let empty:IP.AS = .init(id: $1.asn, domain: $1.domain, name: $1.name)
        $0[$1.asn, default: empty].ranges.append($1.first ... $1.last)
    }

    print("""
        Autonomous System Ranges: \(table.values.reduce(0) { $0 + $1.ranges.count })
        Autonomous Systems: \(table.count)
        """)

    return .init(elements: table.values.sorted { $0.id < $1.id })
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
