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
