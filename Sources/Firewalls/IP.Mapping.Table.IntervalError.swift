import IP

extension IP.Mapping.Table
{
    enum IntervalError:Error
    {
        case nonmonotonic(ClosedRange<Bound>, ClosedRange<Bound>)
    }
}
extension IP.Mapping.Table.IntervalError:CustomStringConvertible
{
    var description:String
    {
        switch self
        {
        case .nonmonotonic(let a, let b):   "Nonmonotonic intervals (\(a), \(b))"
        }
    }
}
