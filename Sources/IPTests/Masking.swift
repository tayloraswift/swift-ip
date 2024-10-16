import IP
import Testing

@Suite
struct Masking
{
    @Test
    static func ipv6() throws
    {
        let value:IP.V6 = .init(
            0x0123,
            0x2345,
            0x3456,
            0x4567,
            0x5678,
            0x6789,
            0x789a,
            0x89ab)

        #expect(value / 0 == .zero)
        #expect(value / 1 == .init(0x0000, 0, 0, 0, 0, 0, 0, 0))
        #expect(value / 8 == .init(0x0100, 0, 0, 0, 0, 0, 0, 0))
        #expect(value / 16 == .init(0x0123, 0, 0, 0, 0, 0, 0, 0))
        #expect(value / 32 == .init(0x0123, 0x2345, 0, 0, 0, 0, 0, 0))
        #expect(value / 60 == .init(0x0123, 0x2345, 0x3456, 0x4560, 0, 0, 0, 0))
        #expect(value / 64 == .init(0x0123, 0x2345, 0x3456, 0x4567, 0, 0, 0, 0))
        #expect(value / 68 == .init(0x0123, 0x2345, 0x3456, 0x4567, 0x5000, 0, 0, 0))
        #expect(value / 96 == .init(
            0x0123,
            0x2345,
            0x3456,
            0x4567,
            0x5678,
            0x6789,
            0,
            0))
        #expect(value / 112 == .init(
            0x0123,
            0x2345,
            0x3456,
            0x4567,
            0x5678,
            0x6789,
            0x789a,
            0))
        #expect(value / 120 == .init(
            0x0123,
            0x2345,
            0x3456,
            0x4567,
            0x5678,
            0x6789,
            0x789a,
            0x8900))
        #expect(value / 127 == .init(
            0x0123,
            0x2345,
            0x3456,
            0x4567,
            0x5678,
            0x6789,
            0x789a,
            0x89aa))
        #expect(value / 128 == value)
    }
}
