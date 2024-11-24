import IP
import JSON

extension IP
{
    /// A helper type to represent a CIDR block that can be either IPv4 or IPv6.
    @frozen @usableFromInline
    enum AnyCIDR
    {
        case v4(Block<V4>)
        case v6(Block<V6>)
    }
}
extension IP.AnyCIDR:CustomStringConvertible
{
    @usableFromInline
    var description:String
    {
        switch self
        {
        case .v4(let block):    block.description
        case .v6(let block):    block.description
        }
    }
}
extension IP.AnyCIDR:LosslessStringConvertible
{
    @usableFromInline
    init?(_ string:some StringProtocol)
    {
        if  let block:IP.Block<IP.V4> = .init(string)
        {
            self = .v4(block)
        }
        else if
            let block:IP.Block<IP.V6> = .init(string)
        {
            self = .v6(block)
        }
        else
        {
            return nil
        }
    }
}
extension IP.AnyCIDR:JSONStringDecodable, JSONStringEncodable
{
}
