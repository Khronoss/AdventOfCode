import Foundation
import Parsing

struct Day19: Challenge {
    var useExampleInput: Bool {
        false
    }

    func execute(
        withInput input: String,
        log: (String, Any?) -> Void
    ) async throws {
        log("Day 19", nil)

        let sections = input.split(separator: "\n\n")
        let towels = sections[0].split(separator: ", ").map(String.init)
        let designs = sections[1].split(separator: "\n").map(String.init)

//        log("Towels", towels)
        let validDesigns = designs
            .map { possibleArrangementsCount(design: $0, from: towels) }
            .filter { $0 > 0 }
//        log("Valid designs", validDesigns)
        log("Possible designs count", validDesigns.count)

        log("Arrangements count:", validDesigns.reduce(0, +))
    }

    func possibleArrangementsCount(design: String, from towels: [String], currentDesign: [String] = []) -> Int {
        let currentDesignString = currentDesign.joined()

        guard currentDesignString.count <= design.count else {
            return 0
        }
        if currentDesignString == design {
            return 1
        }

        let remaining = design[design.index(design.startIndex, offsetBy: currentDesignString.count)...]
        if let cachedCount = Memoization.cache.values[remaining] {
            return cachedCount
        }

        let towelsToTry = towels.filter { towel in
            remaining.hasPrefix(towel)
        }

        let count = towelsToTry.reduce(0, { partialResult, towel in
            partialResult + possibleArrangementsCount(design: design, from: towels, currentDesign: currentDesign + [towel])
        })
        Memoization.cache.values[remaining] = count
        return count
    }

    class Memoization: @unchecked Sendable {
        static let cache = Memoization()

        var values: [String.SubSequence: Int] = [:]
    }
}
