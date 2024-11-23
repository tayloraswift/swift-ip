extension IP
{
    /// Abstracts over ``IP.V4`` and ``IP.V6`` addresses.
    ///
    /// We recommend normalizing all addresses to ``IP.V6`` when possible. However some
    /// applications may derive a performance or security benefit from supporting ``IP.V4``
    /// addresses only, so this protocol enables generic code to support both.
    public
    protocol Address:LosslessStringConvertible, Comparable, Equatable, Hashable, Sendable
    {
        /// The raw storage type for the IP address.
        associatedtype Storage:FixedWidthInteger, UnsignedInteger, BitwiseCopyable

        /// The raw storage, which is the numeric address value in big-endian byte order.
        var storage:Storage { get }

        /// Initializes an IP address from raw storage.
        init(storage:Storage)

        /// Parses an IP address from a string.
        init?(_ string:some StringProtocol)
    }
}
extension IP.Address
{
    /// Initializes an IP address from a logical value.
    ///
    /// For IPv4, the high byte of the ``UInt32`` will become the first octet.
    ///
    /// For IPv6, the high bits of the ``UInt128`` will appear in the high bits of the first
    /// hextet.
    @inlinable public
    init(value:Storage)
    {
        self.init(storage: value.bigEndian)
    }

    /// The logical value of the address.
    ///
    /// For IPv4, the high byte of the ``UInt32`` is the first octet.
    ///
    /// For IPv6, the high bits of the ``UInt128`` come from the high bits of the first hextet.
    @inlinable public
    var value:Storage { .init(bigEndian: self.storage) }
}
extension IP.Address where Self:Comparable
{
    /// Compares two IP addresses by their logical ``value``.
    @inlinable public
    static func < (a:Self, b:Self) -> Bool { a.value < b.value }
}
extension IP.Address
{
    /// The bit width of the IP address type.
    @inlinable
    static var bitWidth:UInt8 { .init(Storage.bitWidth) }

    /// Returns a storage mask where the corresponding logical high `bits` are all 1.
    /// The returned mask itself is in big-endian byte order.
    @inlinable
    static func storageMask(ones bits:UInt8) -> Storage
    {
        let ones:Storage = ~0
        let mask:Storage = ones << (Self.bitWidth - bits)
        return mask.bigEndian
    }

    /// Masks one IP address with another.
    @inlinable public
    static func & (a:Self, b:Self) -> Self { .init(storage: a.storage & b.storage) }

    /// Masks an IP address to the specified number of bits. The meaning of the slash (`/`)
    /// operator follows CIDR notation.
    @inlinable public
    static func / (self:Self, bits:UInt8) -> Self
    {
        .init(storage: self.storage & Self.storageMask(ones: bits))
    }

    /// Replaces all bits in the IP address except for the leading number of `bits` with 1.
    @inlinable public
    static func ^ (self:Self, bits:UInt8) -> Self
    {
        .init(storage: self.storage | ~Self.storageMask(ones: bits))
    }
}
