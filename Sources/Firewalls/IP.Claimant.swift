import BSON
import IP

extension IP
{
    @frozen public
    enum Claimant:String, BSONEncodable, BSONDecodable, Sendable
    {
        case github_actions
        case github_webhook
        case github_other

        /// Google’s “common” crawlers. This used to just be Googlebot, but has since been
        /// co-opted for [Gemini AI](https://gemini.google.com/) training as well.
        case google_common
        /// Google’s “special” crawlers, such as AdsBot.
        case google_special

        /// Microsoft’s Bingbot. Microsoft claims that Bingbot is not used for AI training.
        case microsoft_bingbot
    }
}
