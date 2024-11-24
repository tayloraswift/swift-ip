import BSON
import IP

extension IP
{
    /// An efficient serialized representation of a list of IP ranges.
    ///
    /// This type empirically reduces uncompressed BSON size by about 50 percent, and compressed
    /// size by about 25 percent.
    struct Buffer<Bound>:Sendable where Bound:Address
    {
        var elements:[ClosedRange<Bound>]

        init(_ elements:[ClosedRange<Bound>])
        {
            self.elements = elements
        }
    }
}
extension IP.Buffer
{
    init?(elidingEmpty elements:[ClosedRange<Bound>])
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

extension IP.Buffer:RandomAccessCollection
{
    var startIndex:Int { self.elements.startIndex }

    var endIndex:Int { self.elements.endIndex }

    subscript(position:Int) -> CodingElement
    {
        let range:ClosedRange<Bound> = self.elements[position]
        return (range.lowerBound.storage, range.upperBound.storage)
    }
}
extension IP.Buffer:BSONArrayEncodable
{
}
extension IP.Buffer:BSONArrayDecodable
{
    typealias CodingElement = (Bound.Storage, Bound.Storage)

    init(from bson:borrowing BSON.BinaryArray<CodingElement>) throws
    {
        self.init(bson.map
        {
            let a:Bound = .init(storage: $0)
            let b:Bound = .init(storage: $1)
            if  b < a
            {
                return .init(uncheckedBounds: (b, a))
            }
            else
            {
                return .init(uncheckedBounds: (a, b))
            }
        })
    }
}
