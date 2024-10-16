extension IP
{
    /// An efficient data structure for looking up values associated with IP address ranges.
    @frozen public
    struct Map<Base, Value> where Base:IP.Address
    {
        /// CIDR blocks, sorted by mask length.
        @usableFromInline
        let binades:[(UInt8, [Base: Value])]

        @inlinable
        init(binades:[(UInt8, [Base: Value])])
        {
            self.binades = binades
        }
    }
}
extension IP.Map
{
    /// Constructs an empty IP map.
    @inlinable public
    init()
    {
        self.init(binades: [])
    }

    /// Constructs an IP map from a table of CIDR blocks.
    @inlinable public
    init(indexing table:borrowing IP.BlockTable<Base, Value>)
    {
        var binades:[(UInt8, [Base: Value])] = table.blocks.filter { !$0.value.isEmpty }
        binades.sort { $0.0 < $1.0 }
        self.init(binades: binades)
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
            if  let value:Value = table[needle / length]
            {
                return value
            }
        }

        return nil
    }
}
