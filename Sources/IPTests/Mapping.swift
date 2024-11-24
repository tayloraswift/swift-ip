import IP
import Testing

@Test
func Mapping() throws
{
    let v4:IP.V4 = try #require(.init("1.2.3.4"))
    let v6:IP.V6 = .init(v4: v4)

    #expect(v6 == .init(0, 0, 0, 0, 0, 0xffff, 0x0102, 0x0304))
    #expect(v6 == .init(value: 0xff_ff_01_02_03_04))
    #expect(v6.v4 == v4)
}
