#if canImport(Darwin)
import CNIODarwin
#else
import CNIOLinux
#endif

import IP
import NIOCore

extension IP.V6
{
    /// Creates an IPv6 address from an ``SocketAddress/IPv4Address`` by mapping it to IPv6.
    @inlinable public
    init(_ ip:SocketAddress.IPv4Address)
    {
        self.init(v4: .init(ip))
    }

    /// Creates an IPv6 address from an ``SocketAddress/IPv6Address``.
    @inlinable public
    init(_ ip:SocketAddress.IPv6Address)
    {
        #if canImport(Darwin)
        self.init(storage: ip.address.sin6_addr.__u6_addr.__u6_addr32)
        #else
        self.init(storage: ip.address.sin6_addr.__in6_u.__u6_addr32)
        #endif
    }

    /// Creates an IPv6 address from a ``SocketAddress``. IPv4 addresses are mapped to IPv6.
    /// Returns nil if the address is not an IP address.
    @inlinable public
    init?(_ address:SocketAddress)
    {
        switch address
        {
        case .v4(let ip):       self.init(ip)
        case .v6(let ip):       self.init(ip)
        case .unixDomainSocket: return nil
        }
    }
}
