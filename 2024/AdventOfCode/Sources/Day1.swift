import Foundation
import Parsing

struct Day1: Challenge {
    var body: some Parser<Substring, [(Int, Int)]> {
        Many {
            Int.parser()
            Whitespace()
            Int.parser()
        } separator: {
            "\n"
        }
    }

    func execute(log: (String, Any?) -> Void) {
        let fileName = "Day1_input"
//        let fileName = "Day1_example"

        do {
            let file = try FileReader()
                .readFile(fileName)

            let input = try body.parse(file)
                .reduce(into: ([Int](), [Int]())) {
                    $0.0.append($1.0)
                    $0.1.append($1.1)
                }
            log("parsed", input)

//            let result = getDistances(from: input.0, and: input.1)
            let result = getSimilarityScore(from: input.0, and: input.1)

            log("Result", result)
        } catch {
            log("Failed to read file", error)
        }
    }

    func getDistances(
        from left: [Int],
        and right: [Int]
    ) -> Int {
        zip(left.sorted(), right.sorted())
            .map { abs($0 - $1) }
            .reduce(0, +)
    }

    func getSimilarityScore(
        from left: [Int],
        and right: [Int]
    ) -> Int {
        left.reduce(into: 0) { total, value in
            let count = right.count(where: { $0 == value })

            total += value * count
        }
    }
}
