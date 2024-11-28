import BSON
import BSON_ISO
import IP
import ISO

extension IP
{
    @frozen public
    struct Firewall:Sendable
    {
        private
        let autonomousSystems:[ASN: AS.Metadata]

        public
        let asn:Table<ASN>
        public
        let country:Table<ISO.Country>

        private
        let claimant:Table<Int32>
        private
        let claimants:[Claimant]
        private
        let loopback:Claimant?

        init(
            autonomousSystems:[ASN: AS.Metadata],
            asn:Table<ASN>,
            country:Table<ISO.Country>,
            claimant:Table<Int32>,
            claimants:[Claimant],
            loopback:Claimant?)
        {
            self.autonomousSystems = autonomousSystems
            self.asn = asn
            self.country = country
            self.claimant = claimant
            self.claimants = claimants
            self.loopback = loopback
        }
    }
}
extension IP.Firewall
{
    public
    static func load(from image:Image, loopback:IP.Claimant? = nil) -> Self
    {
        let autonomousSystems:[IP.ASN: IP.AS.Metadata] = image.autonomousSystems.reduce(
            into: [:])
        {
            $0[$1.number] = $1.metadata
        }

        return .init(autonomousSystems: autonomousSystems,
            asn: image.asn,
            country: image.country,
            claimant: image.claimant,
            claimants: image.claimants,
            loopback: loopback)
    }

    public
    func lookup(v4 ip:IP.V4) -> (IP.AS?, IP.Claimant?)
    {
        let asn:IP.ASN? = self.asn[v4: ip]
        let claimant:Int32? = self.claimant[v4: ip]
        return self.symbolicate(asn: asn,
            claimant: claimant,
            loopback: IP.Block<IP.V4>.loopback.contains(ip))
    }
    public
    func lookup(v6 ip:IP.V6) -> (IP.AS?, IP.Claimant?)
    {
        let asn:IP.ASN? = self.asn[v6: ip]
        let claimant:Int32? = self.claimant[v6: ip]
        return self.symbolicate(asn: asn,
            claimant: claimant,
            loopback: IP.Block<IP.V6>.loopback.contains(ip))
    }

    private
    func symbolicate(asn:IP.ASN?,
        claimant:Int32?,
        loopback:Bool) -> (IP.AS?, IP.Claimant?)
    {
        let autonomousSystem:IP.AS?
        if  let asn:IP.ASN,
            let metadata:IP.AS.Metadata = self.autonomousSystems[asn]
        {
            autonomousSystem = .init(number: asn, metadata: metadata)
        }
        else
        {
            autonomousSystem = nil
        }

        let claimant:IP.Claimant? = claimant.map { self.claimants[Int.init($0)] }

        return (autonomousSystem, claimant ?? (loopback ? self.loopback : nil))
    }
}
