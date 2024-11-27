import BSON
import BSON_ISO
import IP

extension IP
{
    @frozen public
    struct Firewall:Sendable
    {
        private
        let autonomousSystems:[ASN: AS.Metadata]
        private
        let claimants:[Claimant]
        private
        let colors:Table<Color>
        private
        let claims:Table<Int32>
        private
        let loopback:Claimant?

        init(
            autonomousSystems:[ASN: AS.Metadata],
            claimants:[Claimant],
            colors:Table<Color>,
            claims:Table<Int32>,
            loopback:Claimant? = nil)
        {
            self.autonomousSystems = autonomousSystems
            self.claimants = claimants
            self.colors = colors
            self.claims = claims
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
            claimants: image.claimants,
            colors: image.colors,
            claims: image.claims,
            loopback: loopback)
    }

    public
    func lookup(v4 ip:IP.V4) -> (mapping:IP.Mapping?, claimant:IP.Claimant?)
    {
        let color:IP.Color? = self.colors[v4: ip]
        let claimant:Int32? = self.claims[v4: ip]
        return self.symbolicate(color: color,
            claimant: claimant,
            loopback: IP.Block<IP.V4>.loopback.contains(ip))
    }
    public
    func lookup(v6 ip:IP.V6) -> (mapping:IP.Mapping?, claimant:IP.Claimant?)
    {
        let color:IP.Color? = self.colors[v6: ip]
        let claimant:Int32? = self.claims[v6: ip]
        return self.symbolicate(color: color,
            claimant: claimant,
            loopback: IP.Block<IP.V6>.loopback.contains(ip))
    }

    private
    func symbolicate(color:IP.Color?,
        claimant:Int32?,
        loopback:Bool) -> (IP.Mapping?, IP.Claimant?)
    {
        let claimant:IP.Claimant? = claimant.map { self.claimants[Int.init($0)] }
        let mapping:IP.Mapping? = color.map
        {
            let autonomousSystem:IP.AS?
            if  let metadata:IP.AS.Metadata = self.autonomousSystems[$0.asn]
            {
                autonomousSystem = .init(number: $0.asn, metadata: metadata)
            }
            else
            {
                autonomousSystem = nil
            }

            return .init(autonomousSystem: autonomousSystem, country: $0.country)
        }

        return (mapping, claimant ?? (loopback ? self.loopback : nil))
    }
}
