import BSON
import IP

extension IP
{
    @frozen public
    enum WhitelistEntity:String, BSONEncodable, BSONDecodable, Sendable
    {
        case github_actions
        case github_webhook
        case github_other

        case google_common
        case google_special

        case microsoft_bingbot
    }
}
