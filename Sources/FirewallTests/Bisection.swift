import Firewalls
import IP
import Testing

@Suite
struct Bisection
{
    @Test
    static func validation() throws
    {
        #expect(throws: (any Error).self)
        {
            try IP.Mapping<String>.init(v4: [(10 ... 19, "a"), (0 ... 9, "b")])
        }

        #expect(throws: (any Error).self)
        {
            try IP.Mapping<String>.init(v4: [(0 ... 10, "a"), (10 ... 10, "b")])
        }

        #expect(throws: (any Error).self)
        {
            try IP.Mapping<String>.init(v4: [(0 ... 10, "a"), (5 ... 10, "b")])
        }

        #expect(throws: (any Error).self)
        {
            try IP.Mapping<String>.init(v4: [(0 ... 10, "a"), (0 ... 10, "b")])
        }

        #expect(throws: (any Error).self)
        {
            try IP.Mapping<String>.init(v4: [(5 ... 15, "a"), (0 ... 10, "b")])
        }
    }

    @Test
    static func bisection() throws
    {
        let empty:IP.Mapping<String> = try .init(v4: [], v6: [])

        #expect(empty.color(containing: 0) == nil)

        let ips:IP.Mapping<String> = try .init(
            v4: [
                ( 1 ... 10, "a"),
                (11 ... 20, "b"),
                (22 ... 30, "c"),
            ],
            v6: [
                (11 ... 20, "d"),
            ])

        #expect(ips.color(containing: .init(v4: 0)) == nil)
        #expect(ips.color(containing: .init(v4: 1)) == "a")
        #expect(ips.color(containing: .init(v4: 9)) == "a")
        #expect(ips.color(containing: .init(v4: 10)) == "a")
        #expect(ips.color(containing: .init(v4: 11)) == "b")
        #expect(ips.color(containing: .init(v4: 19)) == "b")
        #expect(ips.color(containing: .init(v4: 20)) == "b")
        #expect(ips.color(containing: .init(v4: 21)) == nil)
        #expect(ips.color(containing: .init(v4: 22)) == "c")
        #expect(ips.color(containing: .init(v4: 30)) == "c")
        #expect(ips.color(containing: .init(v4: 31)) == nil)

        #expect(ips.color(containing: 0) == nil)
        #expect(ips.color(containing: 1) == nil)
        #expect(ips.color(containing: 10) == nil)
        #expect(ips.color(containing: 11) == "d")
        #expect(ips.color(containing: 19) == "d")
        #expect(ips.color(containing: 20) == "d")
        #expect(ips.color(containing: 21) == nil)
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

        let ips:IP.Mapping<Void> = try .init(v6: blocks.map { ($0.range, ()) })

        #expect(ips.color(containing: 0xAAAA_AAAA_AAAA_AAA9_FFFF_FFFF_FFFF_FFFF) == nil)
        #expect(ips.color(containing: 0xAAAA_AAAA_AAAA_AAAA_0000_0000_0000_0000) != nil)
        #expect(ips.color(containing: 0xAAAA_AAAA_AAAA_AAAA_0000_0000_0000_0001) != nil)
        #expect(ips.color(containing: 0xAAAA_AAAA_AAAA_AAAA_FFFF_FFFF_FFFF_FFFF) != nil)
        #expect(ips.color(containing: 0xAAAA_AAAA_AAAA_AAAB_0000_0000_0000_0000) == nil)

        #expect(ips.color(containing: 0xBBBB_BBBB_BBBB_BBBB_AFFF_FFFF_FFFF_FFFF) == nil)
        #expect(ips.color(containing: 0xBBBB_BBBB_BBBB_BBBB_B000_0000_0000_0000) != nil)
        #expect(ips.color(containing: 0xBBBB_BBBB_BBBB_BBBB_B000_0000_0000_0001) != nil)
        #expect(ips.color(containing: 0xBBBB_BBBB_BBBB_BBBB_BFFF_FFFF_FFFF_FFFF) != nil)
        #expect(ips.color(containing: 0xBBBB_BBBB_BBBB_BBBB_C000_0000_0000_0000) == nil)

        #expect(ips.color(containing: 0xCCCC_CCCC_CCCC_CCCC_CBFF_FFFF_FFFF_FFFF) == nil)
        #expect(ips.color(containing: 0xCCCC_CCCC_CCCC_CCCC_CC00_0000_0000_0000) != nil)
        #expect(ips.color(containing: 0xCCCC_CCCC_CCCC_CCCC_CC00_0000_0000_0001) != nil)
        #expect(ips.color(containing: 0xCCCC_CCCC_CCCC_CCCC_CCFF_FFFF_FFFF_FFFF) != nil)
        #expect(ips.color(containing: 0xCCCC_CCCC_CCCC_CCCC_CD00_0000_0000_0000) == nil)

        #expect(ips.color(containing: 0xDDDD_DDDD_DDDD_DDDD_DDCF_FFFF_FFFF_FFFF) == nil)
        #expect(ips.color(containing: 0xDDDD_DDDD_DDDD_DDDD_DDD0_0000_0000_0000) != nil)
        #expect(ips.color(containing: 0xDDDD_DDDD_DDDD_DDDD_DDD0_0000_0000_0001) != nil)
        #expect(ips.color(containing: 0xDDDD_DDDD_DDDD_DDDD_DDDF_FFFF_FFFF_FFFF) != nil)
        #expect(ips.color(containing: 0xDDDD_DDDD_DDDD_DDDD_DDE0_0000_0000_0000) == nil)

        #expect(ips.color(containing: 0xEEEE_EEEE_EEEE_EEEE_EEED_FFFF_FFFF_FFFF) == nil)
        #expect(ips.color(containing: 0xEEEE_EEEE_EEEE_EEEE_EEEE_0000_0000_0000) != nil)
        #expect(ips.color(containing: 0xEEEE_EEEE_EEEE_EEEE_EEEE_0000_0000_0001) != nil)
        #expect(ips.color(containing: 0xEEEE_EEEE_EEEE_EEEE_EEEE_FFFF_FFFF_FFFF) != nil)
        #expect(ips.color(containing: 0xEEEE_EEEE_EEEE_EEEE_EEEF_0000_0000_0000) == nil)
    }
}
