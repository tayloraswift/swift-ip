import BSON
import IP

extension IP
{
    /// An [Autonomous System](https://en.wikipedia.org/wiki/Autonomous_system_(Internet))
    /// Number (ASN).
    @frozen public
    struct ASN:Equatable, Hashable, Sendable
    {
        public
        let value:UInt32

        @inlinable public
        init(value:UInt32)
        {
            self.value = value
        }
    }
}
extension IP.ASN:ExpressibleByIntegerLiteral
{
    @inlinable public
    init(integerLiteral:UInt32) { self.init(value: integerLiteral) }
}
extension IP.ASN:Comparable
{
    @inlinable public
    static func < (a:Self, b:Self) -> Bool { a.value < b.value }
}
extension IP.ASN:CustomStringConvertible
{
    @inlinable public
    var description:String { "\(value)" }
}
extension IP.ASN:LosslessStringConvertible
{
    @inlinable public
    init?(_ string:some StringProtocol)
    {
        guard
        let value:UInt32 = .init(string)
        else
        {
            return nil
        }

        self.init(value: value)
    }
}
extension IP.ASN:BSON.BinaryPackable
{
    @inlinable public
    static func get(_ storage:UInt32) -> Self { .init(value: .get(storage)) }

    @inlinable public
    consuming func set() -> UInt32 { self.value.set() }
}
extension IP.ASN:BSONEncodable
{
    /// Encodes the ASN as a signed BSON ``Int32``, by mapping the range of the ``UInt32``
    /// value to the range of an ``Int32``.
    ///
    /// The transformation effectively shifts the encoded values by ``Int32.min``. This ensures
    /// the correct database sort behavior, but also means that the numeric values observable in
    /// BSON dumps are nonsensical.
    @inlinable public
    func encode(to field:inout BSON.FieldEncoder)
    {
        //  0          - x = Int32.min
        //  UInt32.max - x = Int32.max
        (Int32.init(bitPattern: self.value) &+ Int32.min).encode(to: &field)
    }
}
extension IP.ASN:BSONDecodable
{
    @inlinable public
    init(bson:BSON.AnyValue) throws
    {
        self.init(value: UInt32.init(bitPattern: try Int32.init(bson: bson) &- Int32.min))
    }
}
