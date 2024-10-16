#if canImport(Darwin)
import CNIODarwin
#else
import CNIOLinux
#endif

import IP
import NIOCore

extension IP.V6
{
    /// Creates an IPv6 address from a ``SocketAddress``. IPv4 addresses are mapped to IPv6.
    @inlinable public
    init?(_ address:SocketAddress)
    {
        switch address
        {
        case .v4(let ip):
            self.init(v4: .init(storage: ip.address.sin_addr.s_addr))

        case .v6(let ip):
            #if canImport(Darwin)
            self.init(storage: ip.address.sin6_addr.__u6_addr.__u6_addr32)
            #else
            self.init(storage: ip.address.sin6_addr.__in6_u.__u6_addr32)
            #endif

        case .unixDomainSocket:
            return nil
        }
    }
}
