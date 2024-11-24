import JSON

extension JSONDecodable
{
    static func decode(parsing file:String) throws -> Self
    {
        let json:JSON = .init(utf8: [UInt8].init(file.utf8)[...])
        return try json.decode()
    }
}
