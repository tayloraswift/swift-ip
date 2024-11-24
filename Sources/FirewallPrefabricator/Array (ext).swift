import JSON

extension Array where Element:JSONDecodable
{
    static func splitting(_ file:String, where delimiter:(Character) -> Bool) throws -> Self
    {
        var i:String.Index = file.startIndex
        var elements:Self = []

        while let j:String.Index = file[i...].firstIndex(where: delimiter)
        {
            let json:JSON = .init(utf8: [UInt8].init(file[i ..< j].utf8)[...])
            elements.append(try json.decode())
            i = file.index(after: j)
        }
        if  i != file.endIndex
        {
            // JSON is missing trailing newline
            let json:JSON = .init(utf8: [UInt8].init(file[i...].utf8)[...])
            elements.append(try json.decode())
        }

        return elements
    }
}
