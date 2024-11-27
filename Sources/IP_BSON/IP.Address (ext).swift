import BSON
import IP

extension IP.Address where Self:BSON.BinaryPackable, Storage:BSON.BinaryPackable
{
    @inlinable public
    static func get(_ storage:Storage) -> Self { .init(storage: storage) }

    @inlinable public
    func set() -> Storage { self.storage }
}
