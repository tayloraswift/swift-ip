import IP

extension IP.AS
{
    /// The human-readable ``name`` and associated ``domain`` of an Autonomous System.
    @frozen public
    struct Metadata:Equatable, Sendable
    {
        /// A web domain associated with the Autonomous System.
        public
        let domain:String
        /// A human-readable name for the Autonomous System.
        public
        let name:String

        @inlinable public
        init(domain:String, name:String)
        {
            self.domain = domain
            self.name = name
        }
    }
}
