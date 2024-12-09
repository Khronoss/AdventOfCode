import Foundation
import Parsing

struct FileReader {
    enum Errors: Error {
        case fileNotFound(String)
        case couldNotReadFile(Error)
    }

    func readFile(
        _ name: String,
        fileExtension: String = "txt"
    ) throws -> String {
        guard let path = Bundle.module.path(forResource: name, ofType: fileExtension) else {
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
