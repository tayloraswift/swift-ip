import IP

extension IP.Table.SortedArray where Bound:Sendable
{
    enum IntervalError:Error
    {
        case nonmonotonic(ClosedRange<Bound>, ClosedRange<Bound>)
    }
}
extension IP.Table.SortedArray.IntervalError:CustomStringConvertible
{
    var description:String
    {
        switch self
        {
        case .nonmonotonic(let a, let b):   "Nonmonotonic intervals (\(a), \(b))"
        }
    }
}
