import BSON
import IP

extension IP.V6:BSONBinaryEncodable
{
    /// Encodes the IPv6 address as a BSON binary array of ``BSON.BinarySubtype/generic``
    /// subtype.
    @inlinable public
    func encode(to bson:inout BSON.BinaryEncoder)
    {
        withUnsafeBytes(of: self) { bson += $0 }
    }
}
extension IP.V6:BSONBinaryDecodable
{
    /// Decodes an IPv6 address from a BSON binary array of ``BSON.BinarySubtype/generic``
    /// subtype.
    @inlinable public
    init(bson:BSON.BinaryDecoder) throws
    {
        try bson.subtype.expect(.generic)

        if  let ip:IP.V6 = .copy(from: bson.bytes)
        {
            self = ip
        }
        else
        {
            throw BSON.ShapeError.init(invalid: bson.bytes.count, expected: .length(16))
        }
    }
}

extension IP.V6:BSON.BinaryPackable
{
}
