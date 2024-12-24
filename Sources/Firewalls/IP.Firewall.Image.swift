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
        var asn:IP.Table<IP.ASN>
        @usableFromInline
        var country:IP.Table<ISO.Country>
        @usableFromInline
        var claimant:IP.Table<Int32>
        @usableFromInline
        var claimants:[IP.Claimant]

        @inlinable public
        init(autonomousSystems:[IP.AS] = [])
        {
            self.autonomousSystems = autonomousSystems
            self.asn = .init()
            self.country = .init()
            self.claimant = .init()
            self.claimants = []
        }
    }
}
extension IP.Firewall.Image
{
    public mutating
    func colorByASN(
        v4:[(IP.ASN, ip:ClosedRange<IP.V4>)],
        v6:[(IP.ASN, ip:ClosedRange<IP.V6>)]) throws
    {
        var v4Ranges:BSON.BinaryArray<ClosedRange<IP.V4>> = .init(count: v4.count)
        var v4Colors:BSON.BinaryArray<IP.ASN> = .init(count: v4.count)

        for (i, (asn, ip)):(Int, (IP.ASN, ClosedRange<IP.V4>)) in zip(
            v4Ranges.indices,
            v4)
        {
            v4Ranges[i] = ip
            v4Colors[i] = asn
        }

        var v6Ranges:BSON.BinaryArray<ClosedRange<IP.V6>> = .init(count: v6.count)
        var v6Colors:BSON.BinaryArray<IP.ASN> = .init(count: v6.count)

        for (i, (asn, ip)):(Int, (IP.ASN, ClosedRange<IP.V6>)) in zip(
            v6Ranges.indices,
            v6)
        {
            v6Ranges[i] = ip
            v6Colors[i] = asn
        }

        self.asn = .init(
            v4: try .init(checking: v4Ranges, colors: v4Colors),
            v6: try .init(checking: v6Ranges, colors: v6Colors))
    }

    public mutating
    func colorByCountry(
        v4:[(ISO.Country, ip:ClosedRange<IP.V4>)],
        v6:[(ISO.Country, ip:ClosedRange<IP.V6>)]) throws
    {
        var v4Ranges:BSON.BinaryArray<ClosedRange<IP.V4>> = .init(count: v4.count)
        var v4Colors:BSON.BinaryArray<ISO.Country> = .init(count: v4.count)

        for (i, (country, ip)):(Int, (ISO.Country, ClosedRange<IP.V4>)) in zip(
            v4Ranges.indices,
            v4)
        {
            v4Ranges[i] = ip
            v4Colors[i] = country
        }

        var v6Ranges:BSON.BinaryArray<ClosedRange<IP.V6>> = .init(count: v6.count)
        var v6Colors:BSON.BinaryArray<ISO.Country> = .init(count: v6.count)

        for (i, (country, ip)):(Int, (ISO.Country, ClosedRange<IP.V6>)) in zip(
            v6Ranges.indices,
            v6)
        {
            v6Ranges[i] = ip
            v6Colors[i] = country
        }

        self.country = .init(
            v4: try .init(checking: v4Ranges, colors: v4Colors),
            v6: try .init(checking: v6Ranges, colors: v6Colors))
    }

    public mutating
    func colorByClaimant(
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

        var v4Ranges:BSON.BinaryArray<ClosedRange<IP.V4>> = .init(count: v4.count)
        var v4Claims:BSON.BinaryArray<Int32> = .init(count: v4.count)

        for (i, (claimant, ip)):(Int, (IP.Claimant, ClosedRange<IP.V4>)) in zip(
            v4Ranges.indices,
            v4)
        {
            v4Ranges[i] = ip
            v4Claims[i] = index(claimant)
        }

        var v6Ranges:BSON.BinaryArray<ClosedRange<IP.V6>> = .init(count: v6.count)
        var v6Claims:BSON.BinaryArray<Int32> = .init(count: v6.count)

        for (i, (claimant, ip)):(Int, (IP.Claimant, ClosedRange<IP.V6>)) in zip(
            v6Ranges.indices,
            v6)
        {
            v6Ranges[i] = ip
            v6Claims[i] = index(claimant)
        }

        self.claimant = .init(
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

        case asn_v4_ranges
        case asn_v4_colors
        case asn_v6_ranges
        case asn_v6_colors

        case country_v4_ranges
        case country_v4_colors
        case country_v6_ranges
        case country_v6_colors

        case claimant_v4_ranges
        case claimant_v4_colors
        case claimant_v6_ranges
        case claimant_v6_colors

        case claimants
    }
}
extension IP.Firewall.Image:BSONDocumentEncodable
{
    public
    func encode(to bson:inout BSON.DocumentEncoder<CodingKey>)
    {
        bson[.autonomousSystems] = self.autonomousSystems

        bson[.asn_v4_ranges] = self.asn.v4.ranges
        bson[.asn_v4_colors] = self.asn.v4.colors
        bson[.asn_v6_ranges] = self.asn.v6.ranges
        bson[.asn_v6_colors] = self.asn.v6.colors

        bson[.country_v4_ranges] = self.country.v4.ranges
        bson[.country_v4_colors] = self.country.v4.colors
        bson[.country_v6_ranges] = self.country.v6.ranges
        bson[.country_v6_colors] = self.country.v6.colors

        bson[.claimant_v4_ranges] = self.claimant.v4.ranges
        bson[.claimant_v4_colors] = self.claimant.v4.colors
        bson[.claimant_v6_ranges] = self.claimant.v6.ranges
        bson[.claimant_v6_colors] = self.claimant.v6.colors

        bson[.claimants] = self.claimants
    }
}
extension IP.Firewall.Image:BSONDocumentDecodable
{
    public
    init(bson:BSON.DocumentDecoder<CodingKey>) throws
    {
        self.init(autonomousSystems: try bson[.autonomousSystems].decode())

        self.asn = .init(
            v4: try .init(
                checking: bson[.asn_v4_ranges].decode(),
                colors: bson[.asn_v4_colors].decode()),
            v6: try .init(
                checking: bson[.asn_v6_ranges].decode(),
                colors: bson[.asn_v6_colors].decode()))

        self.country = .init(
            v4: try .init(
                checking: bson[.country_v4_ranges].decode(),
                colors: bson[.country_v4_colors].decode()),
            v6: try .init(
                checking: bson[.country_v6_ranges].decode(),
                colors: bson[.country_v6_colors].decode()))

        self.claimant = .init(
            v4: try .init(
                checking: bson[.claimant_v4_ranges].decode(),
                colors: bson[.claimant_v4_colors].decode()),
            v6: try .init(
                checking: bson[.claimant_v6_ranges].decode(),
                colors: bson[.claimant_v6_colors].decode()))

        self.claimants = try bson[.claimants].decode()
    }
}
