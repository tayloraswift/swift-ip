import BSON
import BSON_ISO
import IP
import ISO

extension IP
{
    @frozen public
    struct Firewall:Sendable
    {
        public
        var autonomousSystems:[AS]
        public
        var countries:[Claims<ISO.Country>]
        public
        var claimants:[Claims<Claimant>]

        @inlinable public
        init(autonomousSystems:[AS] = [],
            countries:[Claims<ISO.Country>] = [],
            claimants:[Claims<Claimant>] = [])
        {
            self.autonomousSystems = autonomousSystems
            self.countries = countries
            self.claimants = claimants
        }
    }
}
extension IP.Firewall
{
    @frozen public
    enum CodingKey:String, Sendable
    {
        case autonomousSystems
        case countries
        case claimants
    }
}
extension IP.Firewall:BSONDocumentEncodable
{
    public
    func encode(to bson:inout BSON.DocumentEncoder<CodingKey>)
    {
        bson[.autonomousSystems] = self.autonomousSystems
        bson[.countries] = self.countries
        bson[.claimants] = self.claimants
    }
}
extension IP.Firewall:BSONDocumentDecodable
{
    public
    init(bson:BSON.DocumentDecoder<CodingKey>) throws
    {
        self.init(
            autonomousSystems: try bson[.autonomousSystems].decode(),
            countries: try bson[.countries].decode(),
            claimants: try bson[.claimants].decode())
    }
}
