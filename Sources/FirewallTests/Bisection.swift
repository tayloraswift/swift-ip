import Firewalls
import IP
import ISO
import Testing

@Suite
struct Bisection
{
    @Test(arguments: [
        [10 ... 19, 0 ... 9],
        [0 ... 10, 10 ... 10],
        [0 ... 10, 5 ... 10],
        [0 ... 10, 0 ... 10],
        [5 ... 15, 0 ... 10],
    ])
    static func validation(_ ranges:[ClosedRange<IP.V4>]) throws
    {
        var image:IP.Firewall.Image = .init(autonomousSystems: [])

        #expect(throws: (any Error).self)
        {
            try image.colorByCountry(v4: ranges.map { (.US, $0) }, v6: [])
        }
    }

    @Test
    static func bisection() throws
    {
        let empty:IP.Firewall = .load(from: .init(autonomousSystems: []))

        #expect(empty.lookup(v6: 0) == (nil, nil))

        var image:IP.Firewall.Image = .init(autonomousSystems: [])
        try image.colorByCountry(
            v4: [
                (.US,  1 ... 10),
                (.GB, 11 ... 20),
                (.IL, 22 ... 30),
            ],
            v6: [
                (.UA, 11 ... 20),
            ])

        let firewall:IP.Firewall = .load(from: image)

        #expect(firewall.country[v6: 0] == nil)
        #expect(firewall.country[v6: 1] == nil)
        #expect(firewall.country[v6: 10] == nil)
        #expect(firewall.country[v6: 11] == .UA)
        #expect(firewall.country[v6: 19] == .UA)
        #expect(firewall.country[v6: 20] == .UA)
        #expect(firewall.country[v6: 21] == nil)

        #expect(firewall.country[v4: 0] == nil)
        #expect(firewall.country[v4: 1] == .US)
        #expect(firewall.country[v4: 9] == .US)
        #expect(firewall.country[v4: 10] == .US)
        #expect(firewall.country[v4: 11] == .GB)
        #expect(firewall.country[v4: 19] == .GB)
        #expect(firewall.country[v4: 20] == .GB)
        #expect(firewall.country[v4: 21] == nil)
        #expect(firewall.country[v4: 22] == .IL)
        #expect(firewall.country[v4: 30] == .IL)
        #expect(firewall.country[v4: 31] == nil)

        #expect(firewall.country[v6: .init(v4: 0)] == nil)
        #expect(firewall.country[v6: .init(v4: 1)] == .US)
        #expect(firewall.country[v6: .init(v4: 9)] == .US)
        #expect(firewall.country[v6: .init(v4: 10)] == .US)
        #expect(firewall.country[v6: .init(v4: 11)] == .GB)
        #expect(firewall.country[v6: .init(v4: 19)] == .GB)
        #expect(firewall.country[v6: .init(v4: 20)] == .GB)
        #expect(firewall.country[v6: .init(v4: 21)] == nil)
        #expect(firewall.country[v6: .init(v4: 22)] == .IL)
        #expect(firewall.country[v6: .init(v4: 30)] == .IL)
        #expect(firewall.country[v6: .init(v4: 31)] == nil)
    }

    @Test
    static func cidr() throws
    {
        let blocks:[IP.Block<IP.V6>] = [
            0xAAAA_AAAA_AAAA_AAAA_0000_0000_0000_0000 / 64,
            0xBBBB_BBBB_BBBB_BBBB_B000_0000_0000_0000 / 68,
            0xCCCC_CCCC_CCCC_CCCC_CC00_0000_0000_0000 / 72,
            0xDDDD_DDDD_DDDD_DDDD_DDD0_0000_0000_0000 / 76,
            0xEEEE_EEEE_EEEE_EEEE_EEEE_0000_0000_0000 / 80,
        ]

        var image:IP.Firewall.Image = .init(autonomousSystems: [])
        try image.colorByCountry(v4: [], v6: blocks.map { (.US, $0.range) })

        let firewall:IP.Firewall = .load(from: image)

        #expect(firewall.country[v6: 0xAAAA_AAAA_AAAA_AAA9_FFFF_FFFF_FFFF_FFFF] == nil)
        #expect(firewall.country[v6: 0xAAAA_AAAA_AAAA_AAAA_0000_0000_0000_0000] != nil)
        #expect(firewall.country[v6: 0xAAAA_AAAA_AAAA_AAAA_0000_0000_0000_0001] != nil)
        #expect(firewall.country[v6: 0xAAAA_AAAA_AAAA_AAAA_FFFF_FFFF_FFFF_FFFF] != nil)
        #expect(firewall.country[v6: 0xAAAA_AAAA_AAAA_AAAB_0000_0000_0000_0000] == nil)

        #expect(firewall.country[v6: 0xBBBB_BBBB_BBBB_BBBB_AFFF_FFFF_FFFF_FFFF] == nil)
        #expect(firewall.country[v6: 0xBBBB_BBBB_BBBB_BBBB_B000_0000_0000_0000] != nil)
        #expect(firewall.country[v6: 0xBBBB_BBBB_BBBB_BBBB_B000_0000_0000_0001] != nil)
        #expect(firewall.country[v6: 0xBBBB_BBBB_BBBB_BBBB_BFFF_FFFF_FFFF_FFFF] != nil)
        #expect(firewall.country[v6: 0xBBBB_BBBB_BBBB_BBBB_C000_0000_0000_0000] == nil)

        #expect(firewall.country[v6: 0xCCCC_CCCC_CCCC_CCCC_CBFF_FFFF_FFFF_FFFF] == nil)
        #expect(firewall.country[v6: 0xCCCC_CCCC_CCCC_CCCC_CC00_0000_0000_0000] != nil)
        #expect(firewall.country[v6: 0xCCCC_CCCC_CCCC_CCCC_CC00_0000_0000_0001] != nil)
        #expect(firewall.country[v6: 0xCCCC_CCCC_CCCC_CCCC_CCFF_FFFF_FFFF_FFFF] != nil)
        #expect(firewall.country[v6: 0xCCCC_CCCC_CCCC_CCCC_CD00_0000_0000_0000] == nil)

        #expect(firewall.country[v6: 0xDDDD_DDDD_DDDD_DDDD_DDCF_FFFF_FFFF_FFFF] == nil)
        #expect(firewall.country[v6: 0xDDDD_DDDD_DDDD_DDDD_DDD0_0000_0000_0000] != nil)
        #expect(firewall.country[v6: 0xDDDD_DDDD_DDDD_DDDD_DDD0_0000_0000_0001] != nil)
        #expect(firewall.country[v6: 0xDDDD_DDDD_DDDD_DDDD_DDDF_FFFF_FFFF_FFFF] != nil)
        #expect(firewall.country[v6: 0xDDDD_DDDD_DDDD_DDDD_DDE0_0000_0000_0000] == nil)

        #expect(firewall.country[v6: 0xEEEE_EEEE_EEEE_EEEE_EEED_FFFF_FFFF_FFFF] == nil)
        #expect(firewall.country[v6: 0xEEEE_EEEE_EEEE_EEEE_EEEE_0000_0000_0000] != nil)
        #expect(firewall.country[v6: 0xEEEE_EEEE_EEEE_EEEE_EEEE_0000_0000_0001] != nil)
        #expect(firewall.country[v6: 0xEEEE_EEEE_EEEE_EEEE_EEEE_FFFF_FFFF_FFFF] != nil)
        #expect(firewall.country[v6: 0xEEEE_EEEE_EEEE_EEEE_EEEF_0000_0000_0000] == nil)
    }
}
