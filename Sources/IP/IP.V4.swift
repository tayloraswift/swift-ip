extension IP
{
    /// An IPv4 address, which is 32 bits wide.
    @frozen public
    struct V4:Equatable, Hashable, Sendable
    {
        /// The raw address, in big-endian byte order.
        ///
        /// The logical value of the integer varies depending on the platform byte order.
        /// For example, printing the integer will give different results on big-endian and
        /// little-endian platforms.
        public
        var storage:UInt32

        /// Creates an IPv4 address by wrapping a raw **big-endian** integer.
        @inlinable public
        init(storage:UInt32)
        {
            self.storage = storage
        }
    }
}
extension IP.V4
{
    /// Returns the most common loopback address, `127.0.0.1`. Most people reaching for this
    /// API actually want ``IP.Block.loopback [5JXTL]``, which models the entire loopback range.
    @inlinable public
    static var localhost:Self { .init(value: 0x7F_00_00_01) }

    /// Creates an IPv4 address from a 32-bit logical value. The high byte of the ``UInt32``
    /// will become the first octet.
    @inlinable public
    init(value:UInt32)
    {
        self.init(storage: value.bigEndian)
    }

    /// The logical value of the address. The high byte is the first octet.
    @inlinable public
    var value:UInt32 { UInt32.init(bigEndian: self.storage) }
}
extension IP.V4:Comparable
{
    /// Compares two IPv4 addresses by their logical ``value``.
    @inlinable public static
    func < (a:Self, b:Self) -> Bool { a.value < b.value }
}
extension IP.V4:IP.Address
{
    /// An IPv4 address is 32 bits wide.
    @inlinable public static
    var bitWidth:UInt8 { 32 }

    @inlinable public static
    func & (a:Self, b:Self) -> Self
    {
        .init(storage: a.storage & b.storage)
    }

    @inlinable public static
    func / (self:Self, bits:UInt8) -> Self
    {
        let ones:UInt32 = ~0
        let mask:UInt32 = ones << (32 - bits)
        return .init(storage: self.storage & mask.bigEndian)
    }
}
extension IP.V4:CustomStringConvertible
{
    /// Formats the address as a string in dotted-decimal notation.
    @inlinable public
    var description:String
    {
        withUnsafeBytes(of: self.storage) { "\($0[0]).\($0[1]).\($0[2]).\($0[3])" }
    }
}
extension IP.V4:LosslessStringConvertible
{
    /// Parses an IPv4 address from a string in dotted-decimal notation.
    @inlinable public
    init?(_ description:some StringProtocol)
    {
        guard
        var b:String.Index = description.firstIndex(of: "."),
        let a:UInt8 = .init(description[..<b])
        else
        {
            return nil
        }

        b = description.index(after: b)

        guard
        var c:String.Index = description[b...].firstIndex(of: "."),
        let b:UInt8 = .init(description[b ..< c])
        else
        {
            return nil
        }

        c = description.index(after: c)

        guard
        var d:String.Index = description[c...].firstIndex(of: "."),
        let c:UInt8 = .init(description[c ..< d])
        else
        {
            return nil
        }

        d = description.index(after: d)

        guard
        let d:UInt8 = .init(description[d...])
        else
        {
            return nil
        }

        let value:UInt32 =
            UInt32.init(a) << 24 |
            UInt32.init(b) << 16 |
            UInt32.init(c) <<  8 |
            UInt32.init(d)

        self.init(value: value)
    }
}
