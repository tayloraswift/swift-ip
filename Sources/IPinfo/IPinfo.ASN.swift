import IP
import JSON

extension IPinfo
{
    /// A helper type for parsing and formatting an ASN with the `AS` prefix.
    struct ASN
    {
        let parsed:IP.ASN
    }
}
extension IPinfo.ASN:CustomStringConvertible
{
    var description:String { "AS\(self.parsed)" }
}
extension IPinfo.ASN:LosslessStringConvertible
{
    init?(_ string:String)
    {
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

        self.parsed = parsed
    }
}
extension IPinfo.ASN:JSONStringDecodable, JSONStringEncodable
{
}
