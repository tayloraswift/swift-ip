import BSON
import IP

extension IP.Table
{
    @frozen @usableFromInline
    struct SortedArray<Bound> where Bound:Comparable, Bound:BSON.BinaryPackable
    {
        @usableFromInline
        let ranges:BSON.BinaryArray<ClosedRange<Bound>>
        @usableFromInline
        let colors:BSON.BinaryArray<Color>

        @inlinable
        init()
        {
            self.ranges = []
            self.colors = []
        }

        init(
            unchecked ranges:BSON.BinaryArray<ClosedRange<Bound>>,
            colors:BSON.BinaryArray<Color>)
        {
            self.ranges = ranges
            self.colors = colors
        }
    }
}
extension IP.Table.SortedArray where Bound:Sendable
{
    init(
        checking ranges:BSON.BinaryArray<ClosedRange<Bound>>,
        colors:BSON.BinaryArray<Color>) throws
    {
        guard ranges.count == colors.count
        else
        {
            fatalError("unimplemented")
        }

        var last:ClosedRange<Bound>?

        for range:ClosedRange<Bound> in ranges
        {
            if  let last:ClosedRange<Bound>
            {
                if  last.upperBound >= range.lowerBound
                {
                    throw IntervalError.nonmonotonic(last, range)
                }
            }

            last = range
        }

        self.init(unchecked: ranges, colors: colors)
    }
}
extension IP.Table.SortedArray:Sendable where Color:Sendable
{
}
extension IP.Table.SortedArray
{
    @inlinable
    func color(containing ip:Bound) -> Color?
    {
        let index:Int = self.index(containing: ip)
        if  index == self.ranges.endIndex
        {
            return nil
        }

        let range:ClosedRange<Bound> = self.ranges[index]
        //  We already know that `ip <= range.upperBound`
        if  ip < range.lowerBound
        {
            return nil
        }
        else
        {
            return self.colors[index]
        }
    }

    @inlinable
    func index(containing ip:Bound) -> Int
    {
        var n:Int = self.ranges.count
        var l:Int = self.ranges.startIndex

        while n > 0
        {
            let half:Int = n / 2
            let mid:Int = self.ranges.index(l, offsetBy: half)

            if  ip <= self.ranges[mid].upperBound
            {
                n = half
            }
            else
            {
                l = self.ranges.index(after: mid)
                n -= half + 1
            }
        }

        return l
    }
}
