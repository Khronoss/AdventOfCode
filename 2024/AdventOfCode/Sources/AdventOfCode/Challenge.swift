import Foundation
import FileReader

protocol Challenge {
    var useExampleInput: Bool { get }
    var fileName: String { get }

    func execute(
        withInput input: String,
        log: (String, Any?) -> Void
    ) async throws
}

extension Challenge {
    var fileName: String {
        if useExampleInput {
            "\(Self.self)_example"
        } else {
            "\(Self.self)_input"
        }
    }
}

struct ChallengeRunner {
    func run<C: Challenge>(
        _ challenge: C,
        logger: (String, Any?) -> Void
    ) async {
        do {
            let file = try FileReader()
                .readFile(challenge.fileName, from: .module)

            try await challenge.execute(withInput: file, log: logger)
        } catch {
            logger("Failed running challenge \(C.self)", error)
        }
    }
}
