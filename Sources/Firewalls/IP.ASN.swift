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
extension IP.ASN:BSONEncodable
{
    @inlinable public
    func encode(to field:inout BSON.FieldEncoder)
    {
        Int32.init(bitPattern: self.value).encode(to: &field)
    }
}
extension IP.ASN:BSONDecodable
{
    @inlinable public
    init(bson:BSON.AnyValue) throws
    {
        self.init(value: UInt32.init(bitPattern: try Int32.init(bson: bson)))
    }
}
