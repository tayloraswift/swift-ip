extension IP
{
    /// An efficient data structure for looking up values associated with IP address ranges.
    @frozen public
    struct Map<Base, Value> where Base:IP.Address
    {
        /// CIDR blocks, sorted by mask length.
        ///
        /// TODO: Is this really the most efficient search strategy? Perhaps we would be better
        /// off with a “dumb” array of sorted intervals, and a binary search.
        @usableFromInline
        let binades:[(UInt8, [Base: Value])]

        @inlinable
        init(binades:[(UInt8, [Base: Value])])
        {
            self.binades = binades
        }
    }
}
extension IP.Map:ExpressibleByDictionaryLiteral
{
    /// Constructs an empty IP map.
    @inlinable public
    init(dictionaryLiteral:(Never, Value)...)
    {
        self.init(binades: [])
    }
}
extension IP.Map
{
    /// Constructs an IP map from a table of CIDR blocks.
    public
    init(indexing table:borrowing [IP.Block<Base>: Value])
    {
        let binades:[UInt8: [Base: Value]] = table.reduce(into: [:])
        {
            $0[$1.key.bits, default: [:]][$1.key.base] = $1.value
        }
        self.init(binades: binades.sorted { $0.key < $1.key })
    }
}
extension IP.Map:Sendable where Value:Sendable
{
}
extension IP.Map
{
    /// Indicates whether the map is empty.
    @inlinable public
    var isEmpty:Bool { self.binades.isEmpty }

    /// Looks up the value associated with the specified IP address.
    ///
    /// This subscript uses a prefix length strategy to check the longest address ranges first,
    /// which is optimal for uniformly-distributed address queries. This means if the map
    /// contains overlapping ranges, the value associated with the longest prefix always takes
    /// precedence.
    @inlinable public
    subscript(needle:Base) -> Value?
    {
        for (length, table):(UInt8, [Base: Value]) in self.binades
        {
            if  let value:Value = table[needle.zeroMasked(to: length)]
            {
                return value
            }
        }

        return nil
    }
}
