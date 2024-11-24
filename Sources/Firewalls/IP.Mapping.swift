import BSON
import IP

extension IP
{
    @frozen public
    struct Mapping<Color>
    {
        @usableFromInline
        var v4:Table<V4>
        @usableFromInline
        var v6:Table<V6>

        public
        init(
            v4:[(ClosedRange<V4>, Color)] = [],
            v6:[(ClosedRange<V6>, Color)] = []) throws
        {
            self.v4 = try .init(checking: v4)
            self.v6 = try .init(checking: v6)
        }
    }
}
extension IP.Mapping:Sendable where Color:Sendable
{
}
extension IP.Mapping
{
    @inlinable public
    subscript(v4 ip:IP.V4) -> Color?
    {
        self.v4.color(containing: ip)
    }

    @inlinable public
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
