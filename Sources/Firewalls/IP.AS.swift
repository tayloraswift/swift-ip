import BSON
import IP
import IP_BSON

extension IP
{
    /// Describes an
    /// [Autonomous System](https://en.wikipedia.org/wiki/Autonomous_system_(Internet)) (AS).
    @frozen public
    struct AS:Hashable, Equatable, Sendable
    {
        public
        let number:ASN
        public
        var domain:String
        public
        var name:String

        @inlinable public
        init(number:ASN, domain:String, name:String)
        {
            self.number = number
            self.domain = domain
            self.name = name
        }
    }
}
extension IP.AS
{
    @inlinable public
    init(number:IP.ASN, metadata:Metadata)
    {
        self.init(number: number, domain: metadata.domain, name: metadata.name)
    }

    @inlinable public
    var metadata:Metadata { .init(domain: self.domain, name: self.name) }
}
extension IP.AS
{
    @frozen public
    enum CodingKey:String, Sendable
    {
        case number = "I"
        case domain = "D"
        case name = "N"
    }
}
extension IP.AS:BSONDocumentEncodable
{
    public
    func encode(to bson:inout BSON.DocumentEncoder<CodingKey>)
    {
        bson[.number] = self.number
        bson[.domain] = self.domain
        bson[.name] = self.name
    }
}
extension IP.AS:BSONDocumentDecodable
{
    public
    init(bson:BSON.DocumentDecoder<CodingKey>) throws
    {
        self.init(
            number: try bson[.number].decode(),
            domain: try bson[.domain].decode(),
            name: try bson[.name].decode())
    }
}
