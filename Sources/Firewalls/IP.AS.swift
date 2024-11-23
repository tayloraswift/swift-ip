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
        var v4:[ClosedRange<IP.V4>]
        public
        var v6:[ClosedRange<IP.V6>]

        public
        var domain:String
        public
        var name:String

        @inlinable public
        init(id:ASN,
            v4:[ClosedRange<IP.V4>] = [],
            v6:[ClosedRange<IP.V6>] = [],
            domain:String,
            name:String)
        {
            self.id = id
            self.v4 = v4
            self.v6 = v6
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
        case v4 = "4"
        case v6 = "6"
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
        bson[.v4] = IP.Buffer<IP.V4>.init(elidingEmpty: self.v4)
        bson[.v6] = IP.Buffer<IP.V6>.init(elidingEmpty: self.v6)
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
            v4: try bson[.v4]?.decode(as: IP.Buffer<IP.V4>.self, with: \.elements) ?? [],
            v6: try bson[.v6]?.decode(as: IP.Buffer<IP.V6>.self, with: \.elements) ?? [],
            domain: try bson[.domain].decode(),
            name: try bson[.name].decode())
    }
}
