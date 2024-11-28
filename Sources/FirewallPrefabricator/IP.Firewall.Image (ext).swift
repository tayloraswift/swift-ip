import IP
import IPinfo
import ISO

extension IP.Firewall.Image
{
    static func build(from ranges:[IPinfo.ASNRange]) throws -> Self
    {
        var v4:[(IP.ASN, ip:ClosedRange<IP.V4>)]
        var v6:[(IP.ASN, ip:ClosedRange<IP.V6>)]

        let table:[IP.ASN: IP.AS]

        (as: table, v4: v4, v6: v6) = ranges.reduce(into: ([:], [], []))
        {
            $0.as[$1.asn] = .init(number: $1.asn, domain: $1.domain, name: $1.name)

            if  let first:IP.V4 = $1.first.v4,
                let last:IP.V4 = $1.last.v4
            {
                $0.v4.append(($1.asn, first ... last))
            }
            else
            {
                $0.v6.append(($1.asn, $1.first ... $1.last))
            }
        }

        v4.sort { $0.ip.lowerBound < $1.ip.lowerBound }
        v6.sort { $0.ip.lowerBound < $1.ip.lowerBound }

        var image:Self = .init(autonomousSystems: table.values.sorted { $0.number < $1.number })
        try image.colorByASN(v4: v4, v6: v6)

        return image
    }

    mutating
    func colorByCountry(from ranges:[IPinfo.CountryRange]) throws
    {
        var v4:[(ISO.Country, ip:ClosedRange<IP.V4>)]
        var v6:[(ISO.Country, ip:ClosedRange<IP.V6>)]

        (v4: v4, v6: v6) = ranges.reduce(into: ([], []))
        {
            if  let first:IP.V4 = $1.first.v4,
                let last:IP.V4 = $1.last.v4
            {
                $0.v4.append(($1.country, first ... last))
            }
            else
            {
                $0.v6.append(($1.country, $1.first ... $1.last))
            }
        }

        v4.sort { $0.ip.lowerBound < $1.ip.lowerBound }
        v6.sort { $0.ip.lowerBound < $1.ip.lowerBound }

        try self.colorByCountry(v4: v4, v6: v6)
    }

    mutating
    func colorByClaimant(_ claims:[IP.Claims]) throws
    {
        var v4:[(IP.Claimant, ip:ClosedRange<IP.V4>)]
        var v6:[(IP.Claimant, ip:ClosedRange<IP.V6>)]

        (v4: v4, v6: v6) = claims.reduce(into: ([], []))
        {
            for range:ClosedRange<IP.V4> in $1.v4
            {
                $0.v4.append(($1.id, range))
            }
            for range:ClosedRange<IP.V6> in $1.v6
            {
                $0.v6.append(($1.id, range))
            }
        }

        v4.sort { $0.ip.lowerBound < $1.ip.lowerBound }
        v6.sort { $0.ip.lowerBound < $1.ip.lowerBound }

        try self.colorByClaimant(v4: v4, v6: v6)
    }
}
