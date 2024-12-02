import Foundation

struct FileReader {
    enum Error: Swift.Error {
        case fileNotFound
    }

    func lines(
        fromFile fileName: String,
        extension: String = "txt"
    ) throws -> [String] {
        let bundle = Bundle.module

        guard let url = bundle.url(
            forResource: fileName,
            withExtension: `extension`
        ) else {
            throw Error.fileNotFound
        }

        let fileContent = try String(contentsOf: url)

        return fileContent
            .split(separator: "\n")
            .map(String.init)
    }
}
