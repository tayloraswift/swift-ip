import BSON
import IP
import IP_BSON

extension IP
{
    @frozen public
    struct AS:Identifiable
    {
        public
        let id:ASN

        public
        var ranges:[ClosedRange<IP.V6>]
        public
        var domain:String
        public
        var name:String

        @inlinable public
        init(id:ASN, ranges:[ClosedRange<IP.V6>] = [], domain:String, name:String)
        {
            self.id = id
            self.ranges = ranges
            self.domain = domain
            self.name = name
        }
    }
}
extension IP.AS
{
    @frozen public
    enum CodingKey:String, Sendable
    {
        case id = "_id"
        case ranges = "R"
        case domain = "D"
        case name = "N"
    }
}
extension IP.AS:BSONDocumentEncodable
{
    public
    func encode(to bson:inout BSON.DocumentEncoder<CodingKey>)
    {
        bson[.id] = self.id
        bson[.ranges] = IP.V6.Buffer.init(elidingEmpty: self.ranges)
        bson[.domain] = self.domain
        bson[.name] = self.name
    }
}
extension IP.AS:BSONDocumentDecodable
{
    public
    init(bson:BSON.DocumentDecoder<CodingKey>) throws
    {
        self.init(id: try bson[.id].decode(),
            ranges: try bson[.ranges].decode(as: IP.V6.Buffer.self, with: \.elements),
            domain: try bson[.domain].decode(),
            name: try bson[.name].decode())
    }
}
