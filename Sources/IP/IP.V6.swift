extension IP
{
    /// An IPv6 address, which is 128 bits wide.
    @frozen public
    struct V6:Equatable, Hashable, Sendable
    {
        /// The raw 128-bit address, in big-endian byte order. The byte at the lowest address
        /// appears in the high bits of the first hextet.
        ///
        /// The logical value of the integer varies depending on the platform byte order.
        /// For example, printing the integer will give different results on big-endian and
        /// little-endian platforms.
        public
        var storage:UInt128

        /// Creates an IPv6 address by wrapping a raw **big-endian** integer.
        @inlinable public
        init(storage:UInt128)
        {
            self.storage = storage
        }
    }
}
extension IP.V6
{
    /// Initializes an IPv6 address from a tuple of 32-bit words, with elements in big-endian
    /// byte order.
    @inlinable package
    init(storage:(UInt32, UInt32, UInt32, UInt32))
    {
        self = withUnsafeBytes(of: storage) { .copy(buffer: $0) }
    }

    /// Initializes an IPv6 address from a tuple of 16-bit words, with elements in big-endian
    /// byte order.
    @inlinable package
    init(storage:(UInt16, UInt16, UInt16, UInt16, UInt16, UInt16, UInt16, UInt16))
    {
        self = withUnsafeBytes(of: storage) { .copy(buffer: $0) }
    }

    /// Initializes an IPv6 address from 16-bit components, each in **platform byte order**.
    @inlinable public
    init(
        _ a:UInt16,
        _ b:UInt16,
        _ c:UInt16,
        _ d:UInt16,
        _ e:UInt16,
        _ f:UInt16,
        _ g:UInt16,
        _ h:UInt16)
    {
        self.init(storage:
        (
            a.bigEndian,
            b.bigEndian,
            c.bigEndian,
            d.bigEndian,
            e.bigEndian,
            f.bigEndian,
            g.bigEndian,
            h.bigEndian
        ))
    }
}
extension IP.V6
{
    /// Maps an IPv4 address to an IPv6 address in the `::ffff:0:0/96` range.
    @inlinable public
    init(v4:IP.V4)
    {
        let tag:UInt32 = 0x0000_ffff
        self.init(storage: (0, 0, tag.bigEndian, v4.storage))
    }

    /// Returns the IPv4 address mapped to this IPv6 address, if the address is in the
    /// `::ffff:0:0/96` range.
    @inlinable public
    var v4:IP.V4?
    {
        withUnsafeBytes(of: self.storage)
        {
            switch $0.load(as: (UInt64, UInt16, UInt16, UInt32).self)
            {
            case (0x0000_0000_0000_0000, 0x0000, 0xffff, let d):
                return .init(storage: d)

            default:
                return nil
            }
        }
    }
}
extension IP.V6
{
    /// Initializes an IPv6 address from a buffer of 16 bytes, using the first byte as the high
    /// bits of the first hextet, returning nil if the buffer is not 16 bytes long.
    @inlinable public
    static func copy(from bytes:some RandomAccessCollection<UInt8>) -> Self?
    {
        bytes.count == MemoryLayout<UInt128>.size ? .copy(buffer: bytes) : nil
    }

    @inlinable
    static func copy(buffer:some RandomAccessCollection<UInt8>) -> Self
    {
        precondition(buffer.count == MemoryLayout<UInt128>.size)

        return withUnsafeTemporaryAllocation(
            byteCount: MemoryLayout<UInt128>.size,
            alignment: MemoryLayout<UInt128>.alignment)
        {
            $0.copyBytes(from: buffer)
            return .init(storage: $0.load(as: UInt128.self))
        }
    }
}
extension IP.V6
{
    /// Returns the all-zeros address, `::`.
    @inlinable public
    static var zero:Self { .init(storage: 0) }

    /// Returns the all-ones address, `ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff`.
    @inlinable public
    static var ones:Self { .init(storage: ~0) }

    /// Returns the loopback address, `::1`. There is only one loopback address in IPv6.
    @inlinable public
    static var localhost:Self { .init(value: 1) }

    /// Initializes an IPv6 address from a 128-bit logical value. The high bits of the
    /// ``UInt128`` will appear in the high bits of the first hextet.
    @inlinable public
    init(value:UInt128)
    {
        self.init(storage: value.bigEndian)
    }

    /// The logical value of the address. The high bits of the integer come from the high bits
    /// of the first hextet.
    @inlinable public
    var value:UInt128 { .init(bigEndian: self.storage) }
}
extension IP.V6:Comparable
{
    /// Compares two IPv6 addresses by their logical ``value``.
    @inlinable public static
    func < (a:Self, b:Self) -> Bool { a.value < b.value }
}
extension IP.V6:IP.Address
{
    /// An IPv6 address is 128 bits wide.
    @inlinable public static
    var bitWidth:UInt8 { 128 }

    @inlinable public static
    func & (a:Self, b:Self) -> Self { .init(storage: a.storage & b.storage) }

    @inlinable public static
    func / (self:Self, bits:UInt8) -> Self
    {
        let ones:UInt128 = ~0
        let mask:Self = .init(value: ones << (128 - bits))
        return self & mask
    }
}
extension IP.V6:RandomAccessCollection
{
    /// Always 0.
    @inlinable public
    var startIndex:Int { 0 }

    /// Always 8, the number of 16-bit words in an IPv6 address.
    @inlinable public
    var endIndex:Int { 8 }

    /// Returns the *i*th word of the address, in **platform** byte order.
    @inlinable public
    subscript(i:Int) -> UInt16
    {
        get
        {
            precondition(self.indices ~= i, "index out of range")

            return withUnsafeBytes(of: self)
            {
                let words:UnsafeBufferPointer<UInt16> = $0.bindMemory(to: UInt16.self)
                return .init(bigEndian: words[i])
            }
        }
        set(word)
        {
            precondition(self.indices ~= i, "index out of range")

            withUnsafeMutableBytes(of: &self)
            {
                let words:UnsafeMutableBufferPointer<UInt16> = $0.bindMemory(to: UInt16.self)
                words[i] = word.bigEndian
            }
        }
    }
}
extension IP.V6:CustomStringConvertible
{
    /// Formats the address as a string in colon-hexadecimal notation. This formatter does not
    /// collapse zeros.
    @inlinable public
    var description:String
    {
        self.lazy.map { String.init($0, radix: 16) }.joined(separator: ":")
    }
}
extension IP.V6:LosslessStringConvertible
{
    /// Parses an IPv6 address from a string in colon-hexadecimal notation. This parser accepts
    /// both full and collapsed forms.
    @inlinable public
    init?(_ string:some StringProtocol)
    {
        self = .zero

        var i:String.Index = string.startIndex
        var z:Int = 0
        for w:Int in 0 ..< 8
        {
            guard
            let j:String.Index = string[i...].firstIndex(of: ":")
            else
            {
                guard w == 7,
                let word:UInt16 = .init(string[i...], radix: 16)
                else
                {
                    return nil
                }

                self[w] = word
                return
            }

            guard i < j
            else
            {
                break
            }

            guard
            let word:UInt16 = .init(string[i ..< j], radix: 16)
            else
            {
                return nil
            }

            self[w] = word
            i = string.index(after: j)
            z = w + 1
        }

        var k:String.Index = string.indices.last ?? i
        for w:Int in (z ..< 8).reversed()
        {
            guard
            let j:String.Index = string[i ... k].lastIndex(of: ":")
            else
            {
                return nil
            }

            guard j < k
            else
            {
                break
            }

            guard
            let word:UInt16 = .init(string[string.index(after: j) ... k], radix: 16)
            else
            {
                return nil
            }

            self[w] = word

            guard i < j
            else
            {
                break
            }

            k = string.index(before: j)
        }
    }
}
