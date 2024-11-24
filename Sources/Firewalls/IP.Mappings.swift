import IP
import ISO

extension IP
{
    /// A structure holding the various mappings constructed from a ``Firewall``, along with the
    /// metadata for the Autonomous System (``AS``) mapping.
    @frozen public
    struct Mappings:Sendable
    {
        public
        let autonomousSystemMetadata:[ASN: AS.Metadata]
        public
        let autonomousSystems:Mapping<ASN>
        public
        let countries:Mapping<ISO.Country>
        public
        let claimants:Mapping<Claimant>

        @inlinable public
        init(
            autonomousSystemMetadata:[ASN: AS.Metadata],
            autonomousSystems:Mapping<ASN>,
            countries:Mapping<ISO.Country>,
            claimants:Mapping<Claimant>)
        {
            self.autonomousSystemMetadata = autonomousSystemMetadata
            self.autonomousSystems = autonomousSystems
            self.countries = countries
            self.claimants = claimants
        }
    }
}
extension IP.Mappings
{
    /// Loads and validates the data stored in a ``Firewall``, preparing it for efficient IP
    /// address lookups.
    public
    static func load(from firewall:IP.Firewall) throws -> Self
    {
        let autonomousSystemMetadata:[IP.ASN: IP.AS.Metadata]
        var autonomousSystems:
        (
            v4:[(ClosedRange<IP.V4>, IP.ASN)],
            v6:[(ClosedRange<IP.V6>, IP.ASN)]
        )

        (
            autonomousSystemMetadata,
            autonomousSystems.v4,
            autonomousSystems.v6
        ) = firewall.autonomousSystems.reduce(into: (metadata: [:], v4: [], v6: []))
        {
            $0.metadata[$1.id] = $1.metadata

            for range:ClosedRange<IP.V4> in $1.v4
            {
                $0.v4.append((range, $1.id))
            }
            for range:ClosedRange<IP.V6> in $1.v6
            {
                $0.v6.append((range, $1.id))
            }
        }

        var countries:
        (
            v4:[(ClosedRange<IP.V4>, ISO.Country)],
            v6:[(ClosedRange<IP.V6>, ISO.Country)]
        ) = firewall.countries.reduce(into: ([], []))
        {
            for range:ClosedRange<IP.V4> in $1.v4
            {
                $0.v4.append((range, $1.id))
            }
            for range:ClosedRange<IP.V6> in $1.v6
            {
                $0.v6.append((range, $1.id))
            }
        }

        var claimants:
        (
            v4:[(ClosedRange<IP.V4>, IP.Claimant)],
            v6:[(ClosedRange<IP.V6>, IP.Claimant)]
        ) = firewall.claimants.reduce(into: ([], []))
        {
            for range:ClosedRange<IP.V4> in $1.v4
            {
                $0.v4.append((range, $1.id))
            }
            for range:ClosedRange<IP.V6> in $1.v6
            {
                $0.v6.append((range, $1.id))
            }
        }

        autonomousSystems.v4.sort { $0.0.lowerBound < $1.0.lowerBound }
        autonomousSystems.v6.sort { $0.0.lowerBound < $1.0.lowerBound }
        countries.v4.sort { $0.0.lowerBound < $1.0.lowerBound }
        countries.v6.sort { $0.0.lowerBound < $1.0.lowerBound }
        claimants.v4.sort { $0.0.lowerBound < $1.0.lowerBound }
        claimants.v6.sort { $0.0.lowerBound < $1.0.lowerBound }

        return .init(
            autonomousSystemMetadata: autonomousSystemMetadata,
            autonomousSystems: try .init(
                v4: autonomousSystems.v4,
                v6: autonomousSystems.v6),
            countries: try .init(
                v4: countries.v4,
                v6: countries.v6),
            claimants: try .init(
                v4: claimants.v4,
                v6: claimants.v6))
    }
}
