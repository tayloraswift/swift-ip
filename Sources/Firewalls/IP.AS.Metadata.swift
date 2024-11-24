import IP

extension IP.AS
{
    @frozen public
    struct Metadata:Equatable, Sendable
    {
        public
        let domain:String
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
