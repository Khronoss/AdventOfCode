import Foundation

public struct FileReader {
    public enum Errors: Error {
        case fileNotFound(String)
        case couldNotReadFile(Error)
    }

    public init() {}

    public func readFile(
        _ name: String,
        fileExtension: String = "txt",
        from bundle: Bundle
    ) throws -> String {
        guard let path = bundle.path(forResource: name, ofType: fileExtension) else {
            throw Errors.fileNotFound("\(name).\(fileExtension)")
        }

        do {
            var file = try String(contentsOfFile: path, encoding: .utf8)
            _ = file.removeLast()

            return file
        } catch {
            throw Errors.couldNotReadFile(error)
        }
    }
}
