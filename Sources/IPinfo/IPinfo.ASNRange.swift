import Firewalls
import IP
import JSON

extension IPinfo
{
    @frozen public
    struct ASNRange
    {
        public
        let first:IP.V6
        public
        let last:IP.V6
        public
        let asn:IP.ASN
        public
        let name:String
        public
        let domain:String

        @inlinable public
        init(first:IP.V6, last:IP.V6, asn:IP.ASN, name:String, domain:String)
        {
            self.first = first
            self.last = last
            self.asn = asn
            self.name = name
            self.domain = domain
        }
    }
}
extension IPinfo.ASNRange
{
    @frozen public
    enum CodingKey:String, Sendable
    {
        case start_ip
        case end_ip
        case asn
        case name
        case domain
    }
}
extension IPinfo.ASNRange:JSONObjectEncodable
{
    public
    func encode(to json:inout JSON.ObjectEncoder<CodingKey>)
    {
        json[.start_ip] = IPinfo.Address.init(parsed: self.first)
        json[.end_ip] = IPinfo.Address.init(parsed: self.last)
        json[.asn] = IPinfo.ASN.init(parsed: self.asn)
        json[.name] = self.name
        json[.domain] = self.domain
    }
}
extension IPinfo.ASNRange:JSONObjectDecodable
{
    public
    init(json:JSON.ObjectDecoder<CodingKey>) throws
    {
        self.init(
            first: try json[.start_ip].decode(as: IPinfo.Address.self, with: \.parsed),
            last: try json[.end_ip].decode(as: IPinfo.Address.self, with: \.parsed),
            asn: try json[.asn].decode(as: IPinfo.ASN.self, with: \.parsed),
            name: try json[.name].decode(),
            domain: try json[.domain].decode())
    }
}
