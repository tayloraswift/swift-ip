import IP
import Testing

@Suite
struct Parsing
{
    @Test
    static func localhost4() throws
    {
        #expect(try #require(IP.V4.init("127.0.0.1")) == .localhost)
    }

    @Test
    static func localhost6() throws
    {
        #expect(try #require(IP.V6.init("::1")) == .localhost)
    }

    @Test
    static func zero() throws
    {
        #expect(try #require(IP.V6.init("::")) == .zero)
    }

    @Test
    static func ones() throws
    {
        #expect(try #require(IP.V6.init("ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff")) == .ones)
    }

    @Test
    static func prefix16() throws
    {
        let expected:IP.V6 = .init(0xabcd, 0, 0, 0, 0, 0, 0, 0)
        #expect(try #require(IP.V6.init("abcd::")) == expected)
    }

    @Test
    static func prefix32() throws
    {
        let expected:IP.V6 = .init(0xabcd, 0x1234, 0, 0, 0, 0, 0, 0)
        #expect(try #require(IP.V6.init("abcd:1234::")) == expected)
    }

    @Test
    static func prefix32_16() throws
    {
        let expected:IP.V6 = .init(0xabcd, 0x1234, 0, 0, 0, 0, 0, 0xcdef)
        #expect(try #require(IP.V6.init("abcd:1234::cdef")) == expected)
    }

    @Test
    static func prefix32_32() throws
    {
        let expected:IP.V6 = .init(0xabcd, 0x1234, 0, 0, 0, 0, 0x5678, 0xcdef)
        #expect(try #require(IP.V6.init("abcd:1234::5678:cdef")) == expected)
    }

    @Test
    static func prefix16_32() throws
    {
        let expected:IP.V6 = .init(0xabcd, 0, 0, 0, 0, 0, 0x5678, 0xcdef)
        #expect(try #require(IP.V6.init("abcd::5678:cdef")) == expected)
    }

    @Test
    static func suffix32() throws
    {
        let expected:IP.V6 = .init(0, 0, 0, 0, 0, 0, 0x5678, 0xcdef)
        #expect(try #require(IP.V6.init("::5678:cdef")) == expected)
    }

    @Test
    static func suffix16() throws
    {
        let expected:IP.V6 = .init(0, 0, 0, 0, 0, 0, 0, 0xcdef)
        #expect(try #require(IP.V6.init("::cdef")) == expected)
    }

    @Test
    static func roundtripping4() throws
    {
        let expected:IP.V4 = .init(value: 0x01_02_03_04)
        #expect(try #require(.init("1.2.3.4")) == expected)
        #expect(try #require(.init("\(expected)")) == expected)
    }

    @Test
    static func roundtripping6() throws
    {
        let expected:IP.V6 = .init(
            0x0123,
            0x2345,
            0x3456,
            0x4567,
            0x5678,
            0x6789,
            0x789a,
            0x89ab)

        let actual:IP.V6 = try #require(.init("0123:2345:3456:4567:5678:6789:789a:89ab"))
        let again:IP.V6 = try #require(.init("\(actual)"))

        #expect(expected == actual)
        #expect(expected == again)

        #expect(actual.value == 0x0123_2345_3456_4567_5678_6789_789a_89ab)
        #expect(actual.v4 == nil)
    }
}
