import BSON
import IP

extension IP
{
    @frozen public
    struct Firewall
    {
        public
        var autonomousSystems:[AS]
        public
        var whitelists:[Whitelist]
        public
        var countries:[Country]

        @inlinable public
        init(
            autonomousSystems:[AS] = [],
            whitelists:[Whitelist] = [],
            countries:[Country] = [])
        {
            self.autonomousSystems = autonomousSystems
            self.whitelists = whitelists
            self.countries = countries
        }
    }
}
extension IP.Firewall
{
    @frozen public
    enum CodingKey:String, Sendable
    {
        case autonomousSystems
        case whitelists
        case countries
    }
}
extension IP.Firewall:BSONDocumentEncodable
{
    public
    func encode(to bson:inout BSON.DocumentEncoder<CodingKey>)
    {
        bson[.autonomousSystems] = self.autonomousSystems
        bson[.whitelists] = self.whitelists
        bson[.countries] = self.countries
    }
}
extension IP.Firewall:BSONDocumentDecodable
{
    public
    init(bson:BSON.DocumentDecoder<CodingKey>) throws
    {
        self.init(
            autonomousSystems: try bson[.autonomousSystems].decode(),
            whitelists: try bson[.whitelists].decode(),
            countries: try bson[.countries].decode())
    }
}
