import IP
import Testing

@Suite
struct Masking
{
    private
    let ip:IP.V6 = .init(
        0x0123,
        0x2345,
        0x3456,
        0x4567,
        0x5678,
        0x6789,
        0x789a,
        0x89ab)

    @Test
    func zero() throws
    {
        #expect(self.ip.zeroMasked(to: 0) == .zero)
        #expect(self.ip.zeroMasked(to: 1) == .init(
            0x0000, 0, 0, 0, 0, 0, 0, 0))

        #expect(self.ip.zeroMasked(to: 8) == .init(
            0x0100, 0, 0, 0, 0, 0, 0, 0))

        #expect(self.ip.zeroMasked(to: 16) == .init(
            0x0123, 0, 0, 0, 0, 0, 0, 0))

        #expect(self.ip.zeroMasked(to: 32) == .init(
            0x0123, 0x2345, 0, 0, 0, 0, 0, 0))

        #expect(self.ip.zeroMasked(to: 60) == .init(
            0x0123, 0x2345, 0x3456, 0x4560, 0, 0, 0, 0))

        #expect(self.ip.zeroMasked(to: 64) == .init(
            0x0123, 0x2345, 0x3456, 0x4567, 0, 0, 0, 0))

        #expect(self.ip.zeroMasked(to: 68) == .init(
            0x0123, 0x2345, 0x3456, 0x4567, 0x5000, 0, 0, 0))

        #expect(self.ip.zeroMasked(to: 96) == .init(
            0x0123, 0x2345, 0x3456, 0x4567, 0x5678, 0x6789, 0, 0))

        #expect(self.ip.zeroMasked(to: 112) == .init(
            0x0123, 0x2345, 0x3456, 0x4567, 0x5678, 0x6789, 0x789a, 0))

        #expect(self.ip.zeroMasked(to: 120) == .init(
            0x0123, 0x2345, 0x3456, 0x4567, 0x5678, 0x6789, 0x789a, 0x8900))

        #expect(self.ip.zeroMasked(to: 127) == .init(
            0x0123, 0x2345, 0x3456, 0x4567, 0x5678, 0x6789, 0x789a, 0x89aa))

        #expect(self.ip.zeroMasked(to: 128) == self.ip)
    }

    @Test
    func ones() throws
    {
        #expect(self.ip.onesMasked(to: 0) == .ones)
        #expect(self.ip.onesMasked(to: 1) == .init(
            0x7fff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff))

        #expect(self.ip.onesMasked(to: 8) == .init(
            0x01ff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff))

        #expect(self.ip.onesMasked(to: 16) == .init(
            0x0123, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff))

        #expect(self.ip.onesMasked(to: 32) == .init(
            0x0123, 0x2345, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff, 0xffff))

        #expect(self.ip.onesMasked(to: 60) == .init(
            0x0123, 0x2345, 0x3456, 0x456f, 0xffff, 0xffff, 0xffff, 0xffff))

        #expect(self.ip.onesMasked(to: 64) == .init(
            0x0123, 0x2345, 0x3456, 0x4567, 0xffff, 0xffff, 0xffff, 0xffff))

        #expect(self.ip.onesMasked(to: 68) == .init(
            0x0123, 0x2345, 0x3456, 0x4567, 0x5fff, 0xffff, 0xffff, 0xffff))

        #expect(self.ip.onesMasked(to: 96) == .init(
            0x0123, 0x2345, 0x3456, 0x4567, 0x5678, 0x6789, 0xffff, 0xffff))

        #expect(self.ip.onesMasked(to: 112) == .init(
            0x0123, 0x2345, 0x3456, 0x4567, 0x5678, 0x6789, 0x789a, 0xffff))

        #expect(self.ip.onesMasked(to: 120) == .init(
            0x0123, 0x2345, 0x3456, 0x4567, 0x5678, 0x6789, 0x789a, 0x89ff))

        #expect(self.ip.onesMasked(to: 127) == .init(
            0x0123, 0x2345, 0x3456, 0x4567, 0x5678, 0x6789, 0x789a, 0x89ab))

        #expect(self.ip.onesMasked(to: 128) == self.ip)
    }
}
