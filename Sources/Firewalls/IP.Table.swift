import BSON
import IP
import IP_BSON

extension IP
{
    /// A data structure for efficient IP address lookups.
    ///
    /// IP mappings can be quite large, so you should always ensure the machine you are using
    /// them on has enough memory to store them.
    @frozen @usableFromInline
    struct Table<Color> where Color:BSON.BinaryPackable
    {
        @usableFromInline
        var v4:SortedArray<V4>
        @usableFromInline
        var v6:SortedArray<V6>

        /// Constructs a mapping from lists of IP ranges and associated colors.
        ///
        /// The address ranges must be non-overlapping and sorted in ascending order. If not,
        /// the initializer will throw an error.
        ///
        /// This does not perform any IPv6 to IPv4 normalization, which means IPv6-mapped IPv4
        /// addresses in the `v6` list will never match any queries.
        @inlinable
        init(
            v4:SortedArray<V4> = .init(),
            v6:SortedArray<V6> = .init())
        {
            self.v4 = v4
            self.v6 = v6
        }
    }
}
extension IP.Table:Sendable where Color:Sendable
{
}
extension IP.Table
{
    /// Performs a bisection search to look up the color associated with the given IP address,
    /// using the IPv4 subtable only.
    ///
    /// >   Complexity:
    ///     *O*(log *n*), where *n* is the number of ranges in the IPv4 subtable.
    @inlinable
    subscript(v4 ip:IP.V4) -> Color?
    {
        self.v4.color(containing: ip)
    }

    /// Performs a bisection search to look up the color associated with the given IP address.
    /// If the IP address is an IPv6-mapped IPv4 address, the subscript will use the IPv4
    /// subtable, otherwise it will use the IPv6 subtable.
    ///
    /// >   Complexity:
    ///     *O*(log *n*), where *n* is the number of ranges in the corresponding subtable.
    @inlinable
    subscript(v6 ip:IP.V6) -> Color?
    {
        if  let v4:IP.V4 = ip.v4
        {
            self[v4: v4]
        }
        else
        {
            self.v6.color(containing: ip)
        }
    }
}
