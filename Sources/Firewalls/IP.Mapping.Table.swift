import IP

extension IP.Mapping
{
    @frozen @usableFromInline
    struct Table<Bound> where Bound:Comparable, Bound:Sendable
    {
        @usableFromInline
        let intervals:[(range:ClosedRange<Bound>, color:Color)]

        init(unchecked intervals:[(ClosedRange<Bound>, Color)])
        {
            self.intervals = intervals
        }
    }
}
extension IP.Mapping.Table
{
    init(checking intervals:[(ClosedRange<Bound>, Color)]) throws
    {
        var last:ClosedRange<Bound>?

        for (range, _):(ClosedRange<Bound>, Color) in intervals
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

        self.init(unchecked: intervals)
    }
}
extension IP.Mapping.Table
{
    @inlinable
    func color(containing ip:Bound) -> Color?
    {
        let index:Int = self.index(containing: ip)
        if  index == self.intervals.endIndex
        {
            return nil
        }

        let (range, color):(ClosedRange<Bound>, Color) = self.intervals[index]
        //  We already know that `ip <= range.upperBound`
        if  ip < range.lowerBound
        {
            return nil
        }
        else
        {
            return color
        }
    }

    @inlinable
    func index(containing ip:Bound) -> Int
    {
        var n:Int = self.intervals.count
        var l:Int = self.intervals.startIndex

        while n > 0
        {
            let half:Int = n / 2
            let mid:Int = self.intervals.index(l, offsetBy: half)

            if  ip <= self.intervals[mid].range.upperBound
            {
                n = half
            }
            else
            {
                l = self.intervals.index(after: mid)
                n -= half + 1
            }
        }

        return l
    }
}
