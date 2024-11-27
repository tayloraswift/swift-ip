import Firewalls
import IP
import JSON

extension IPinfo
{
    /// A helper type for parsing and formatting an ASN with the `AS` prefix. If the string is
    /// empty, the ASN is the null ASN, `0`.
    struct ASN
    {
        let parsed:IP.ASN
    }
}
extension IPinfo.ASN:CustomStringConvertible
{
    var description:String { self.parsed == 0 ? "" : "AS\(self.parsed)" }
}
extension IPinfo.ASN:LosslessStringConvertible
{
    init?(_ string:String)
    {
        if  string.isEmpty
        {
            self.init(parsed: 0)
            return
        }

        guard
        let i:String.Index = string.index(string.startIndex,
            offsetBy: 2,
            limitedBy: string.endIndex),
        case "AS" = string[..<i],
        let parsed:IP.ASN = .init(string[i...])
        else
        {
            return nil
        }

        self.init(parsed: parsed)
    }
}
extension IPinfo.ASN:JSONStringDecodable, JSONStringEncodable
{
}
