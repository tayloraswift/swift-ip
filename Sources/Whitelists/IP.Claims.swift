import BSON
import Firewalls
import IP

extension IP
{
    @frozen public
    struct Claims:Identifiable, Sendable
    {
        public
        let id:IP.Claimant

        public
        var v4:[ClosedRange<IP.V4>]
        public
        var v6:[ClosedRange<IP.V6>]

        init(id:IP.Claimant, v4:[ClosedRange<IP.V4>] = [], v6:[ClosedRange<IP.V6>] = [])
        {
            self.id = id
            self.v4 = v4
            self.v6 = v6
        }
    }
}
extension IP.Claims
{
    mutating
    func extend(with blocks:[IP.AnyCIDR])
    {
        for block:IP.AnyCIDR in blocks
        {
            switch block
            {
            case .v4(let block):    self.v4.append(block.range)
            case .v6(let block):    self.v6.append(block.range)
            }
        }
    }
}
