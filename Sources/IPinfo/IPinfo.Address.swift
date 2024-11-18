import IP
import JSON

extension IPinfo
{
    /// A helper type for parsing and formatting addresses that can be either IPv4 or IPv6.
    struct Address
    {
        let parsed:IP.V6
    }
}
extension IPinfo.Address:CustomStringConvertible
{
    var description:String { self.parsed.v4?.description ?? self.parsed.description }
}
extension IPinfo.Address:LosslessStringConvertible
{
    init?(_ string:String)
    {
        if  let v4:IP.V4 = .init(string)
        {
            self.init(parsed: .init(v4: v4))
        }
        else if
            let v6:IP.V6 = .init(string)
        {
            self.init(parsed: v6)
        }
        else
        {
            return nil
        }
    }
}
extension IPinfo.Address:JSONStringDecodable, JSONStringEncodable
{
}
