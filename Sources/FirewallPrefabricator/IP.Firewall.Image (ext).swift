import IP
import IPinfo
import ISO

extension IP.Firewall.Image
{
    static func build(from ranges:[IPinfo.AddressRange]) throws -> Self
    {
        var v4:[(IP.ASN, ISO.Country, ip:ClosedRange<IP.V4>)]
        var v6:[(IP.ASN, ISO.Country, ip:ClosedRange<IP.V6>)]

        let table:[IP.ASN: IP.AS]

        (as: table, v4: v4, v6: v6) = ranges.reduce(into: ([:], [], []))
        {
            let asn:IP.ASN

            if  let autonomousSystem:IP.AS = $1.autonomousSystem
            {
                asn = autonomousSystem.number
                $0.as[asn] = autonomousSystem
            }
            else
            {
                asn = 0
            }

            if  let first:IP.V4 = $1.first.v4,
                let last:IP.V4 = $1.last.v4
            {
                $0.v4.append((asn, $1.country, first ... last))
            }
            else
            {
                $0.v6.append((asn, $1.country, $1.first ... $1.last))
            }
        }

        v4.sort { $0.ip.lowerBound < $1.ip.lowerBound }
        v6.sort { $0.ip.lowerBound < $1.ip.lowerBound }

        var image:Self = .init(autonomousSystems: table.values.sorted { $0.number < $1.number })
        try image.color(v4: v4, v6: v6)

        return image
    }

    mutating
    func claim(_ claims:[IP.Claims]) throws
    {
        var (v4, v6):
        (
            v4:[(IP.Claimant, ip:ClosedRange<IP.V4>)],
            v6:[(IP.Claimant, ip:ClosedRange<IP.V6>)]
        ) = claims.reduce(into: ([], []))
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

        try self.claim(v4: v4, v6: v6)
    }
}
