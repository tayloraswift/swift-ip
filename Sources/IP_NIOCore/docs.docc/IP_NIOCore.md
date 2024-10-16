# ``/IP_NIOCore``

This module provides shims for compatibility with SwiftNIO’s ``SocketAddress/IPv4Address`` and ``SocketAddress/IPv6Address`` types.

The two native ``SocketAddress`` types are reference counted and resilient, which makes them unsuitable for performance-sensitive applications. By contrast, this library’s ``IP.V4`` and ``IP.V6`` types are inline value types that can be passed around with zero overhead.
