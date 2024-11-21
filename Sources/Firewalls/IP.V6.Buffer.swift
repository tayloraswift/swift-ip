import BSON
import IP

extension IP.V6
{
    /// An efficient serialized representation of a list of IPv6 ranges.
    ///
    /// This type empirically reduces uncompressed BSON size by about 50 percent, and compressed
    /// size by about 25 percent.
    struct Buffer:Equatable, Sendable
    {
        var elements:[ClosedRange<IP.V6>]

        init(_ elements:[ClosedRange<IP.V6>])
        {
            self.elements = elements
        }
    }
}
extension IP.V6.Buffer
{
    init?(elidingEmpty elements:[ClosedRange<IP.V6>])
    {
        if  elements.isEmpty
        {
            return nil
        }
        else
        {
            self.init(elements)
        }
    }
}

extension IP.V6.Buffer:RandomAccessCollection
{
    var startIndex:Int { self.elements.startIndex }

    var endIndex:Int { self.elements.endIndex }

    subscript(position:Int) -> CodingElement
    {
        let range:ClosedRange<IP.V6> = self.elements[position]
        return (range.lowerBound.storage, range.upperBound.storage)
    }
}
extension IP.V6.Buffer:BSONArrayEncodable
{
}
extension IP.V6.Buffer:BSONArrayDecodable
{
    typealias CodingElement = (UInt128, UInt128)

    init(from bson:borrowing BSON.BinaryArray<CodingElement>) throws
    {
        self.init(bson.map
        {
            let a:IP.V6 = .init(storage: $0)
            let b:IP.V6 = .init(storage: $1)
            if  b < a
            {
                return b ... a
            }
            else
            {
                return a ... b
            }
        })
    }
}
