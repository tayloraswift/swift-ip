extension IP
{
    /// A representation of a CIDR block.
    ///
    /// Create a CIDR block using the ``Address./(_:_:)`` operator.
    ///
    /// This type wastes a lot of padding, as it stores the prefix length alongside the base
    /// mask, so it is only suitable as a formatter, parser, or interface type.
    ///
    /// Data structures should mask the base addresses using ``Address.zeroMasked(to:)`` and
    /// perform lookups against the masked values.
    @frozen public
    struct Block<Base>:Equatable, Hashable, Sendable where Base:Address
    {
        public
        var base:Base
        public
        var bits:UInt8

        @inlinable
        init(base:Base, bits:UInt8)
        {
            self.base = base
            self.bits = bits
        }
    }
}
extension IP.Block<IP.V6>
{
    /// Converts the IPv4 base address to an IPv6 address and adds 96 to the prefix length.
    @inlinable public
    init(v4:IP.Block<IP.V4>)
    {
        self.init(base: .init(v4: v4.base), bits: v4.bits + 96)
    }

    /// Returns the IPv6 loopback mask, `::1/128`.
    @inlinable public
    static var loopback:Self { .init(base: .localhost, bits: 128) }
}
extension IP.Block<IP.V4>
{
    /// Returns the IPv4 loopback mask, `127.0.0.0/8`.
    @inlinable public
    static var loopback:Self { .init(base: .localhost, bits: 8) }
}
extension IP.Block
{
    @inlinable public
    var range:ClosedRange<Base> { self.base ... self.base.onesMasked(to: self.bits) }
}
extension IP.Block:CustomStringConvertible
{
    /// Formats the block as a string in CIDR notation.
    @inlinable public
    var description:String { "\(self.base)/\(self.bits)" }
}
extension IP.Block:LosslessStringConvertible
{
    /// Parses a CIDR block from a string in CIDR notation.
    @inlinable public
    init?(_ string:some StringProtocol)
    {
        guard
        let slash:String.Index = string.lastIndex(of: "/"),
        let base:Base = .init(string[..<slash]),
        let bits:UInt8 = .init(string[string.index(after: slash)...]),
            bits <= Base.bitWidth
        else
        {
            return nil
        }

        self = base / bits
    }
}
