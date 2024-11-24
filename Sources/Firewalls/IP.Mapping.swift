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
    func color(containing ip:IP.V6) -> Color?
    {
        ip.v4.map(self.v4.color(containing:)) ?? self.v6.color(containing: ip)
    }
}
