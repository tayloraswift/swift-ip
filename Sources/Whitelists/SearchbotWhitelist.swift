import IP
import JSON

/// The common whitelist API format shared between
/// [Googlebot](https://developers.google.com/static/search/apis/ipranges/googlebot.json) and
/// [Bingbot](https://www.bing.com/toolbox/bingbot.json).
@frozen public
struct SearchbotWhitelist
{
    let blocks:[IP.AnyCIDR]

    init(blocks:[IP.AnyCIDR])
    {
        self.blocks = blocks
    }
}
extension SearchbotWhitelist:JSONObjectDecodable
{
    @frozen public
    enum CodingKey:String, Sendable
    {
        case prefixes
        enum Prefix:String, Sendable
        {
            case ipv4Prefix
            case ipv6Prefix
        }
    }

    public
    init(json:JSON.ObjectDecoder<CodingKey>) throws
    {
        let blocks:[IP.AnyCIDR] = try json[.prefixes].decode(as: JSON.Array.self)
        {
            try $0.map
            {
                let object:JSON.ObjectDecoder<CodingKey.Prefix> = try $0.decode()
                let prefix:JSON.FieldDecoder<CodingKey.Prefix> = try object.single()

                switch prefix.key
                {
                case .ipv4Prefix:   return .v4(try prefix.decode())
                case .ipv6Prefix:   return .v6(try prefix.decode())
                }
            }
        }

        self.init(blocks: blocks)
    }
}
