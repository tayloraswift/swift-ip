import BSON
import IP
import Testing

@Suite
struct Roundtripping
{
    /// This checks that the integer transform we use to preserve sorting behavior is sound.
    @Test(arguments: [
        0,
        1,
        0x7FFF_FFFE,
        0x7FFF_FFFF,
        0x8000_0000,
        0x8000_0001,
        0xFFFF_FFFE,
        0xFFFF_FFFF,
    ] as [IP.ASN])
    static func asn(_ asn:IP.ASN) throws
    {
        let expected:IP.AS = .init(number: asn, domain: "", name: "")

        let encoded:BSON.Document = .init(encoding: expected)
        let decoded:IP.AS = try .init(bson: encoded)

        #expect(decoded.number == expected.number)
    }
}
