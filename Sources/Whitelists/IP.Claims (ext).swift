import IP

extension IP.Claims
{
    init(id:ID, blocks:borrowing [IP.AnyCIDR])
    {
        self.init(id: id)
        self.extend(with: blocks)
    }

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
