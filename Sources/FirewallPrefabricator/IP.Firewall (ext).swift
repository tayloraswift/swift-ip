import IP

extension IP.Firewall
{
    mutating
    func build()
    {
        for i:Int in self.autonomousSystems.indices
        {
            self.autonomousSystems[i].v4.sort { $0.lowerBound < $1.lowerBound }
            self.autonomousSystems[i].v6.sort { $0.lowerBound < $1.lowerBound }
        }
        for i:Int in self.countries.indices
        {
            self.countries[i].v4.sort { $0.lowerBound < $1.lowerBound }
            self.countries[i].v6.sort { $0.lowerBound < $1.lowerBound }
        }
        for i:Int in self.claimants.indices
        {
            self.claimants[i].v4.sort { $0.lowerBound < $1.lowerBound }
            self.claimants[i].v6.sort { $0.lowerBound < $1.lowerBound }
        }
    }
}