import Firewalls
import IP
import ISO
import JSON

extension IPinfo
{
    @frozen public
    struct AddressRange
    {
        public
        let autonomousSystem:IP.AS?
        public
        let country:ISO.Country

        public
        let first:IP.V6
        public
        let last:IP.V6

        @inlinable public
        init(autonomousSystem:IP.AS?, country:ISO.Country, first:IP.V6, last:IP.V6)
        {
            self.autonomousSystem = autonomousSystem
            self.country = country
            self.first = first
            self.last = last
        }
    }
}
extension IPinfo.AddressRange
{
    @frozen public
    enum CodingKey:String, Sendable
    {
        case asn
        case as_name
        case as_domain

        case country

        @available(*, unavailable) case country_name
        @available(*, unavailable) case continent
        @available(*, unavailable) case continent_name

        case start_ip
        case end_ip
    }
}
extension IPinfo.AddressRange:JSONObjectDecodable
{
    public
    init(json:JSON.ObjectDecoder<CodingKey>) throws
    {
        let autonomousSystem:IP.AS?
        let number:IP.ASN = try json[.asn].decode(as: IPinfo.ASN.self, with: \.parsed)
        if  number != 0
        {
            autonomousSystem = .init(number: number,
                domain: try json[.as_domain].decode(),
                name: try json[.as_name].decode())
        }
        else
        {
            autonomousSystem = nil
        }

        self.init(autonomousSystem: autonomousSystem,
            country: try json[.country].decode(),
            first: try json[.start_ip].decode(as: IPinfo.Address.self, with: \.parsed),
            last: try json[.end_ip].decode(as: IPinfo.Address.self, with: \.parsed))
    }
}
