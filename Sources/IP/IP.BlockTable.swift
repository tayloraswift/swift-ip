extension IP
{
    /// A helper type for building an ``IP.Map``.
    @frozen public
    struct BlockTable<Base, Value> where Base:IP.Address
    {
        @usableFromInline
        var blocks:[UInt8: [Base: Value]]

        @inlinable public
        init(blocks:[UInt8: [Base: Value]])
        {
            self.blocks = blocks
        }
    }
}
extension IP.BlockTable:Sendable where Value:Sendable
{
}
extension IP.BlockTable:ExpressibleByDictionaryLiteral
{
    /// Initializes a block table from an empty dictionary literal.
    @inlinable public
    init(dictionaryLiteral elements:(UInt8, Never)...)
    {
        self.init(blocks: [:])
    }
}
extension IP.BlockTable
{
    /// Sets a sequence of IP blocks to the specified value. This is the same as setting each
    /// block individually in a loop through ``subscript(_:)``.
    @inlinable public mutating
    func update(blocks:some Sequence<IP.Block<Base>>, with value:Value)
    {
        for block:IP.Block<Base> in blocks
        {
            self[block] = value
        }
    }

    /// Accesses the value associated with the specified block. The table is keyed by the exact
    /// shape of the CIDR block (including prefix length), and does not check for overlapping
    /// address ranges.
    @inlinable public
    subscript(block:IP.Block<Base>) -> Value?
    {
        get
        {
            self.blocks[block.bits]?[block.base]
        }
        set(value)
        {
            self.blocks[block.bits, default: [:]][block.base] = value
        }
    }
}
