import IP
import ISO

extension IP
{
    @frozen public
    struct Mapping:Equatable, Sendable
    {
        public
        let autonomousSystem:AS?
        public
        let country:ISO.Country

        @inlinable public
        init(autonomousSystem:AS?, country:ISO.Country)
        {
            self.autonomousSystem = autonomousSystem
            self.country = country
        }
    }
}
