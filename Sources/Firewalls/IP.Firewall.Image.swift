import BSON
import BSON_ISO
import IP
import ISO

extension IP.Firewall
{
    /// The data used to construct ``IP.Firewall``.
    @frozen public
    struct Image:Sendable
    {
        @usableFromInline
        var autonomousSystems:[IP.AS]
        @usableFromInline
        var claimants:[IP.Claimant]

        @usableFromInline
        var colors:IP.Table<IP.Color>
        @usableFromInline
        var claims:IP.Table<Int32>

        @inlinable public
        init(autonomousSystems:[IP.AS] = [])
        {
            self.autonomousSystems = autonomousSystems
            self.claimants = []
            self.colors = .init()
            self.claims = .init()
        }
    }
}
extension IP.Firewall.Image
{
    public mutating
    func color(
        v4:[(IP.ASN, ISO.Country, ip:ClosedRange<IP.V4>)],
        v6:[(IP.ASN, ISO.Country, ip:ClosedRange<IP.V6>)]) throws
    {
        var v4Ranges:BSON._BinaryArray<ClosedRange<IP.V4>> = .init(count: v4.count)
        var v4Colors:BSON._BinaryArray<IP.Color> = .init(count: v4.count)

        for (i, (asn, country, ip)):(Int, (IP.ASN, ISO.Country, ClosedRange<IP.V4>)) in zip(
            v4Ranges.indices,
            v4)
        {
            v4Ranges[i] = ip
            v4Colors[i] = .init(country: country, asn: asn)
        }

        var v6Ranges:BSON._BinaryArray<ClosedRange<IP.V6>> = .init(count: v6.count)
        var v6Colors:BSON._BinaryArray<IP.Color> = .init(count: v6.count)

        for (i, (asn, country, ip)):(Int, (IP.ASN, ISO.Country, ClosedRange<IP.V6>)) in zip(
            v6Ranges.indices,
            v6)
        {
            v6Ranges[i] = ip
            v6Colors[i] = .init(country: country, asn: asn)
        }

        self.colors = .init(
            v4: try .init(checking: v4Ranges, colors: v4Colors),
            v6: try .init(checking: v6Ranges, colors: v6Colors))
    }

    public mutating
    func claim(
        v4:[(IP.Claimant, ip:ClosedRange<IP.V4>)],
        v6:[(IP.Claimant, ip:ClosedRange<IP.V6>)]) throws
    {
        var claimantIndices:[IP.Claimant: Int] = [:]

        for (j, claimant):(Int, IP.Claimant) in zip(self.claimants.indices, self.claimants)
        {
            claimantIndices[claimant] = j
        }

        func index(_ claimant:IP.Claimant) -> Int32
        {
            let j:Int =
            {
                if  let j:Int = $0
                {
                    return j
                }
                else
                {
                    let j:Int = self.claimants.endIndex
                    self.claimants.append(claimant)
                    return j
                }
            } (&claimantIndices[claimant])
            return Int32.init(j)
        }

        var v4Ranges:BSON._BinaryArray<ClosedRange<IP.V4>> = .init(count: v4.count)
        var v4Claims:BSON._BinaryArray<Int32> = .init(count: v4.count)

        for (i, (claimant, ip)):(Int, (IP.Claimant, ClosedRange<IP.V4>)) in zip(
            v4Ranges.indices,
            v4)
        {
            v4Ranges[i] = ip
            v4Claims[i] = index(claimant)
        }

        var v6Ranges:BSON._BinaryArray<ClosedRange<IP.V6>> = .init(count: v6.count)
        var v6Claims:BSON._BinaryArray<Int32> = .init(count: v6.count)

        for (i, (claimant, ip)):(Int, (IP.Claimant, ClosedRange<IP.V6>)) in zip(
            v6Ranges.indices,
            v6)
        {
            v6Ranges[i] = ip
            v6Claims[i] = index(claimant)
        }

        self.claims = .init(
            v4: try .init(checking: v4Ranges, colors: v4Claims),
            v6: try .init(checking: v6Ranges, colors: v6Claims))
    }
}
extension IP.Firewall.Image
{
    @frozen public
    enum CodingKey:String, Sendable
    {
        case autonomousSystems
        case claimants
        case colors_v4_ranges
        case colors_v4_colors
        case colors_v6_ranges
        case colors_v6_colors
        case claims_v4_ranges
        case claims_v4_colors
        case claims_v6_ranges
        case claims_v6_colors
    }
}
extension IP.Firewall.Image:BSONDocumentEncodable
{
    public
    func encode(to bson:inout BSON.DocumentEncoder<CodingKey>)
    {
        bson[.autonomousSystems] = self.autonomousSystems
        bson[.claimants] = self.claimants

        bson[.colors_v4_ranges] = self.colors.v4.ranges
        bson[.colors_v4_colors] = self.colors.v4.colors
        bson[.colors_v6_ranges] = self.colors.v6.ranges
        bson[.colors_v6_colors] = self.colors.v6.colors

        bson[.claims_v4_ranges] = self.claims.v4.ranges
        bson[.claims_v4_colors] = self.claims.v4.colors
        bson[.claims_v6_ranges] = self.claims.v6.ranges
        bson[.claims_v6_colors] = self.claims.v6.colors
    }
}
extension IP.Firewall.Image:BSONDocumentDecodable
{
    public
    init(bson:BSON.DocumentDecoder<CodingKey>) throws
    {
        self.init(autonomousSystems: try bson[.autonomousSystems].decode())

        self.claimants = try bson[.claimants].decode()
        self.colors = .init(
            v4: try .init(
                checking: bson[.colors_v4_ranges].decode(),
                colors: bson[.colors_v4_colors].decode()),
            v6: try .init(
                checking: bson[.colors_v6_ranges].decode(),
                colors: bson[.colors_v6_colors].decode()))
        self.claims = .init(
            v4: try .init(
                checking: bson[.claims_v4_ranges].decode(),
                colors: bson[.claims_v4_colors].decode()),
            v6: try .init(
                checking: bson[.claims_v6_ranges].decode(),
                colors: bson[.claims_v6_colors].decode()))
    }
}
