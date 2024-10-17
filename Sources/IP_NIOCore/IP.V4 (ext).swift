#if canImport(Darwin)
import CNIODarwin
#else
import CNIOLinux
#endif

import IP
import NIOCore

extension IP.V4
{
    /// Creates an IPv4 address from an ``SocketAddress/IPv4Address``.
    @inlinable public
    init(_ ip:SocketAddress.IPv4Address)
    {
        self.init(storage: ip.address.sin_addr.s_addr)
    }
}
