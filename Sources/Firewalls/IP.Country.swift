import BSON
import BSON_ISO
import IP
import ISO

extension IP
{
    @frozen public
    struct Country:Identifiable
    {
        public
        let id:ISO.Country

        public
        var ranges:[ClosedRange<IP.V6>]

        @inlinable public
        init(id:ISO.Country, ranges:[ClosedRange<IP.V6>] = [])
        {
            self.id = id
            self.ranges = ranges
        }
    }
}
extension IP.Country
{
    @frozen public
    enum CodingKey:String, Sendable
    {
        case id = "_id"
        case ranges = "R"
    }
}
extension IP.Country:BSONDocumentEncodable
{
    public
    func encode(to bson:inout BSON.DocumentEncoder<CodingKey>)
    {
        bson[.id] = self.id
        bson[.ranges] = IP.V6.Buffer.init(elidingEmpty: self.ranges)
    }
}
extension IP.Country:BSONDocumentDecodable
{
    public
    init(bson:BSON.DocumentDecoder<CodingKey>) throws
    {
        self.init(id: try bson[.id].decode(),
            ranges: try bson[.ranges].decode(as: IP.V6.Buffer.self, with: \.elements))
    }
}
