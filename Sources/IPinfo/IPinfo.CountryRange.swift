import IP
import ISO
import JSON

extension IPinfo
{
    @frozen public
    struct CountryRange
    {
        public
        let first:IP.V6
        public
        let last:IP.V6
        public
        let country:ISO.Country

        @inlinable public
        init(first:IP.V6, last:IP.V6, country:ISO.Country)
        {
            self.first = first
            self.last = last
            self.country = country
        }
    }
}
extension IPinfo.CountryRange
{
    @frozen public
    enum CodingKey:String, Sendable
    {
        case start_ip
        case end_ip
        case country

        @available(*, unavailable) case country_name
        @available(*, unavailable) case continent
        @available(*, unavailable) case continent_name
    }
}
extension IPinfo.CountryRange:JSONObjectEncodable
{
    public
    func encode(to json:inout JSON.ObjectEncoder<CodingKey>)
    {
        json[.start_ip] = IPinfo.Address.init(parsed: self.first)
        json[.end_ip] = IPinfo.Address.init(parsed: self.last)
        json[.country] = self.country
    }
}
extension IPinfo.CountryRange:JSONObjectDecodable
{
    public
    init(json:JSON.ObjectDecoder<CodingKey>) throws
    {
        self.init(
            first: try json[.start_ip].decode(as: IPinfo.Address.self, with: \.parsed),
            last: try json[.end_ip].decode(as: IPinfo.Address.self, with: \.parsed),
            country: try json[.country].decode())
    }
}
