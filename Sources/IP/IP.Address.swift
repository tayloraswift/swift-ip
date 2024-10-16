extension IP
{
    /// Abstracts over ``IP.V4`` and ``IP.V6`` addresses.
    ///
    /// We recommend normalizing all addresses to ``IP.V6`` when possible. However some
    /// applications may derive a performance or security benefit from supporting ``IP.V4``
    /// addresses only, so this protocol enables generic code to support both.
    public
    protocol Address:LosslessStringConvertible, Equatable, Hashable, Sendable
    {
        /// Parses an IP address from a string.
        init?(_ string:some StringProtocol)

        /// The bit width of the IP address type.
        static
        var bitWidth:UInt8 { get }

        /// Masks one IP address with another.
        static
        func & (a:Self, b:Self) -> Self

        /// Masks an IP address to the specified number of bits. The meaning of the slash (`/`)
        /// operator follows CIDR notation.
        static
        func / (self:Self, bits:UInt8) -> Self
    }
}
