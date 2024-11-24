import BSON
import IP

extension IP
{
    @frozen public
    struct Whitelist:Identifiable
    {
        public
        let id:WhitelistEntity

        public
        var v4:[ClosedRange<IP.V4>]
        public
        var v6:[ClosedRange<IP.V6>]

        @inlinable public
        init(id:WhitelistEntity, v4:[ClosedRange<IP.V4>] = [], v6:[ClosedRange<IP.V6>] = [])
        {
            self.id = id
            self.v4 = v4
            self.v6 = v6
        }
    }
}
extension IP.Whitelist
{
    @frozen public
    enum CodingKey:String, Sendable
    {
        case id = "_id"
        case v4 = "4"
        case v6 = "6"
    }
}
extension IP.Whitelist:BSONDocumentEncodable
{
    public
    func encode(to bson:inout BSON.DocumentEncoder<CodingKey>)
    {
        bson[.id] = self.id
        bson[.v4] = IP.Buffer<IP.V4>.init(elidingEmpty: self.v4)
        bson[.v6] = IP.Buffer<IP.V6>.init(elidingEmpty: self.v6)
    }
}
extension IP.Whitelist:BSONDocumentDecodable
{
    public
    init(bson:BSON.DocumentDecoder<CodingKey>) throws
    {
        self.init(id: try bson[.id].decode(),
            v4: try bson[.v4]?.decode(as: IP.Buffer<IP.V4>.self, with: \.elements) ?? [],
            v6: try bson[.v6]?.decode(as: IP.Buffer<IP.V6>.self, with: \.elements) ?? [])
    }
}
