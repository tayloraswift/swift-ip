import BSON
import IP
import ISO

extension IP
{
    @frozen @usableFromInline
    struct Color:Sendable
    {
        public
        let country:ISO.Country
        public
        let asn:IP.ASN

        @inlinable public
        init(country:ISO.Country, asn:IP.ASN)
        {
            self.country = country
            self.asn = asn
        }
    }
}
extension IP.Color:BSON.BinaryPackable
{
    /// The order of the tuple elements is important; the ASN has 4-byte alignment, but the
    /// country has 2-byte alignment. If they were reversed, 2 bytes of padding would appear
    /// between the two components.
    @usableFromInline
    typealias Storage = (UInt32, UInt16)

    @inlinable
    consuming func set() -> Storage
    {
        (self.asn.value.bigEndian, self.country.rawValue.bigEndian)
    }

    @inlinable
    static func get(_ storage:Storage) -> Self
    {
        let country:ISO.Country = .init(rawValue: .init(bigEndian: storage.1))
        let asn:IP.ASN = .init(value: .init(bigEndian: storage.0))

        return .init(country: country, asn: asn)
    }
}
