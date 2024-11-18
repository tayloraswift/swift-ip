import FoundationEssentials
import JSON
import IP
import IPinfo
import ISO

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

struct AS:Equatable, Sendable
{
    public
    let domain:String
    public
    let name:String

    init(domain:String, name:String)
    {
        self.domain = domain
        self.name = name
    }
}

let autonomousSystemsFile:String = try .init(
    contentsOf: URL.init(fileURLWithPath: "asn.json"),
    encoding: .utf8)

let autonomousSystemsList:[IPinfo.ASNRange] = try .splitting(autonomousSystemsFile,
    where: \.isNewline)


let autonomousSystemsByRange:[ClosedRange<IP.V6>: IP.ASN] = autonomousSystemsList.reduce(
    into: [:])
{
    $0[$1.first ... $1.last] = $1.asn
}
let autonomousSystems:[IP.ASN: AS] = autonomousSystemsList.reduce(into: [:])
{
    $0[$1.asn] = .init(domain: $1.domain, name: $1.name)
}

print("""
    Autonomous System Ranges: \(autonomousSystemsByRange.count)
    Autonomous Systems: \(autonomousSystems.count)
    """)


let countriesFile:String = try .init(
    contentsOf: URL.init(fileURLWithPath: "country.json"),
    encoding: .utf8)

let countriesList:[IPinfo.CountryRange] = try .splitting(countriesFile,
    where: \.isNewline)

let countriesByRange:[ClosedRange<IP.V6>: ISO.Country] = countriesList.reduce(into: [:])
{
    $0[$1.first ... $1.last] = $1.country
}

let countries:[ISO.Country: Int] = countriesList.reduce(into: [:])
{
    $0[$1.country, default: 0] += 1
}

print("""
    Country Ranges: \(countriesByRange.count)
    Countries: \(countries.count)
    """)
for (country, count):(ISO.Country, Int) in countries.sorted(by: { $0.key < $1.key })
{
    print("    \(country): \(count)")
}
