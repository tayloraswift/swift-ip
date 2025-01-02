extension IP
{
    /// An IPv4 address, which is 32 bits wide.
    @frozen public
    struct V4:Address, ExpressibleByIntegerLiteral
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
    @inlinable public
    init(_ a:UInt8, _ b:UInt8, _ c:UInt8, _ d:UInt8)
    {
        self.init(storage: unsafeBitCast((a, b, c, d), to: UInt32.self))
    }
}
extension IP.V4
{
    /// Returns the most common loopback address, `127.0.0.1`. Most people reaching for this
    /// API actually want ``IP.Block.loopback -> IP.Block<IP.V6>``, which models the entire
    /// loopback range.
    @inlinable public
    static var localhost:Self { .init(value: 0x7F_00_00_01) }
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

        self.init(a, b, c, d)
    }
}
