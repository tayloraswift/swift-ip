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
            try image.color(v4: ranges.map { (0, .us, $0) }, v6: [])
        }
    }

    @Test
    static func bisection() throws
    {
        let empty:IP.Firewall = .load(from: .init(autonomousSystems: []))

        #expect(empty.lookup(v6: 0) == (nil, nil))

        var image:IP.Firewall.Image = .init(autonomousSystems: [])
        try image.color(
            v4: [
                (0, .us,  1 ... 10),
                (0, .gb, 11 ... 20),
                (0, .il, 22 ... 30),
            ],
            v6: [
                (0, .ua, 11 ... 20),
            ])

        let firewall:IP.Firewall = .load(from: image)

        #expect(firewall.lookup(v6: 0).mapping?.country == nil)
        #expect(firewall.lookup(v6: 1).mapping?.country == nil)
        #expect(firewall.lookup(v6: 10).mapping?.country == nil)
        #expect(firewall.lookup(v6: 11).mapping?.country == .ua)
        #expect(firewall.lookup(v6: 19).mapping?.country == .ua)
        #expect(firewall.lookup(v6: 20).mapping?.country == .ua)
        #expect(firewall.lookup(v6: 21).mapping?.country == nil)

        #expect(firewall.lookup(v4: 0).mapping?.country == nil)
        #expect(firewall.lookup(v4: 1).mapping?.country == .us)
        #expect(firewall.lookup(v4: 9).mapping?.country == .us)
        #expect(firewall.lookup(v4: 10).mapping?.country == .us)
        #expect(firewall.lookup(v4: 11).mapping?.country == .gb)
        #expect(firewall.lookup(v4: 19).mapping?.country == .gb)
        #expect(firewall.lookup(v4: 20).mapping?.country == .gb)
        #expect(firewall.lookup(v4: 21).mapping?.country == nil)
        #expect(firewall.lookup(v4: 22).mapping?.country == .il)
        #expect(firewall.lookup(v4: 30).mapping?.country == .il)
        #expect(firewall.lookup(v4: 31).mapping?.country == nil)

        #expect(firewall.lookup(v6: .init(v4: 0)).mapping?.country == nil)
        #expect(firewall.lookup(v6: .init(v4: 1)).mapping?.country == .us)
        #expect(firewall.lookup(v6: .init(v4: 9)).mapping?.country == .us)
        #expect(firewall.lookup(v6: .init(v4: 10)).mapping?.country == .us)
        #expect(firewall.lookup(v6: .init(v4: 11)).mapping?.country == .gb)
        #expect(firewall.lookup(v6: .init(v4: 19)).mapping?.country == .gb)
        #expect(firewall.lookup(v6: .init(v4: 20)).mapping?.country == .gb)
        #expect(firewall.lookup(v6: .init(v4: 21)).mapping?.country == nil)
        #expect(firewall.lookup(v6: .init(v4: 22)).mapping?.country == .il)
        #expect(firewall.lookup(v6: .init(v4: 30)).mapping?.country == .il)
        #expect(firewall.lookup(v6: .init(v4: 31)).mapping?.country == nil)
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
        try image.color(v4: [], v6: blocks.map { (0, .us, $0.range) })

        let firewall:IP.Firewall = .load(from: image)

        #expect(firewall.lookup(v6: 0xAAAA_AAAA_AAAA_AAA9_FFFF_FFFF_FFFF_FFFF).mapping == nil)
        #expect(firewall.lookup(v6: 0xAAAA_AAAA_AAAA_AAAA_0000_0000_0000_0000).mapping != nil)
        #expect(firewall.lookup(v6: 0xAAAA_AAAA_AAAA_AAAA_0000_0000_0000_0001).mapping != nil)
        #expect(firewall.lookup(v6: 0xAAAA_AAAA_AAAA_AAAA_FFFF_FFFF_FFFF_FFFF).mapping != nil)
        #expect(firewall.lookup(v6: 0xAAAA_AAAA_AAAA_AAAB_0000_0000_0000_0000).mapping == nil)

        #expect(firewall.lookup(v6: 0xBBBB_BBBB_BBBB_BBBB_AFFF_FFFF_FFFF_FFFF).mapping == nil)
        #expect(firewall.lookup(v6: 0xBBBB_BBBB_BBBB_BBBB_B000_0000_0000_0000).mapping != nil)
        #expect(firewall.lookup(v6: 0xBBBB_BBBB_BBBB_BBBB_B000_0000_0000_0001).mapping != nil)
        #expect(firewall.lookup(v6: 0xBBBB_BBBB_BBBB_BBBB_BFFF_FFFF_FFFF_FFFF).mapping != nil)
        #expect(firewall.lookup(v6: 0xBBBB_BBBB_BBBB_BBBB_C000_0000_0000_0000).mapping == nil)

        #expect(firewall.lookup(v6: 0xCCCC_CCCC_CCCC_CCCC_CBFF_FFFF_FFFF_FFFF).mapping == nil)
        #expect(firewall.lookup(v6: 0xCCCC_CCCC_CCCC_CCCC_CC00_0000_0000_0000).mapping != nil)
        #expect(firewall.lookup(v6: 0xCCCC_CCCC_CCCC_CCCC_CC00_0000_0000_0001).mapping != nil)
        #expect(firewall.lookup(v6: 0xCCCC_CCCC_CCCC_CCCC_CCFF_FFFF_FFFF_FFFF).mapping != nil)
        #expect(firewall.lookup(v6: 0xCCCC_CCCC_CCCC_CCCC_CD00_0000_0000_0000).mapping == nil)

        #expect(firewall.lookup(v6: 0xDDDD_DDDD_DDDD_DDDD_DDCF_FFFF_FFFF_FFFF).mapping == nil)
        #expect(firewall.lookup(v6: 0xDDDD_DDDD_DDDD_DDDD_DDD0_0000_0000_0000).mapping != nil)
        #expect(firewall.lookup(v6: 0xDDDD_DDDD_DDDD_DDDD_DDD0_0000_0000_0001).mapping != nil)
        #expect(firewall.lookup(v6: 0xDDDD_DDDD_DDDD_DDDD_DDDF_FFFF_FFFF_FFFF).mapping != nil)
        #expect(firewall.lookup(v6: 0xDDDD_DDDD_DDDD_DDDD_DDE0_0000_0000_0000).mapping == nil)

        #expect(firewall.lookup(v6: 0xEEEE_EEEE_EEEE_EEEE_EEED_FFFF_FFFF_FFFF).mapping == nil)
        #expect(firewall.lookup(v6: 0xEEEE_EEEE_EEEE_EEEE_EEEE_0000_0000_0000).mapping != nil)
        #expect(firewall.lookup(v6: 0xEEEE_EEEE_EEEE_EEEE_EEEE_0000_0000_0001).mapping != nil)
        #expect(firewall.lookup(v6: 0xEEEE_EEEE_EEEE_EEEE_EEEE_FFFF_FFFF_FFFF).mapping != nil)
        #expect(firewall.lookup(v6: 0xEEEE_EEEE_EEEE_EEEE_EEEF_0000_0000_0000).mapping == nil)
    }
}
