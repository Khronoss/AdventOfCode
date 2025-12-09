import Parsing
import Foundation

struct Day5 {
    let identifier = "Day5"

    struct Database: Equatable {
        let freshIDRanges: [ClosedRange<Int>]
        let availableIDs: [Int]
    }

    func run(from filePath: URL) throws -> Int {
        let inputText = try String(contentsOf: filePath, encoding: .utf8)
        let database = try parsedDatabase(from: String(inputText.dropLast()))

        return numberOfPossibleIDs(in: database)
    }

    func parsedDatabase(from input: String) throws -> Database {
        try ParsableDataBase().parse(input)
    }

    func numberOfFreshAvailableIDs(in database: Database) -> Int {
        database
            .getAvailableFreshIDs()
            .count
    }

    func numberOfPossibleIDs(in database: Database) -> Int {
        database
            .getMergedFreshIDRanges()
            .reduce(0) { $0 + $1.count }
    }
}

extension Day5.Database {
    func getAvailableFreshIDs() -> [Int] {
        availableIDs
            .filter { id in
                freshIDRanges.contains(where: { $0.contains(id) })
            }
    }

    func getMergedFreshIDRanges() -> [ClosedRange<Int>] {
        freshIDRanges
            .sorted(by: { $0.lowerBound < $1.lowerBound })
            .reduce([ClosedRange<Int>]()) { result, range in
                guard let lastRange = result.last else {
                    return [range]
                }

                if lastRange.overlaps(range) {
                    let newRange = lastRange.union(with: range)

                    return result.dropLast() + [newRange]
                } else {
                    return result + [range]
                }
            }
    }
}

extension ClosedRange<Int> {
    func union(with other: Self) -> Self {
        Swift.min(lowerBound, other.lowerBound)...Swift.max(upperBound, other.upperBound)
    }
}

struct ParsableDataBase: Parser {
    var ranges: some Parser<Substring, [ClosedRange<Int>]> {
        Many {
            Parse {
                $0...$1
            } with: {
                Int.parser()
                "-"
                Int.parser()
            }
        } separator: {
            "\n"
        }
    }

    var availableIDs: some Parser<Substring, [Int]> {
        Many {
            Int.parser()
        } separator: {
            "\n"
        }
    }

    var body: some Parser<Substring, Day5.Database> {
        Parse(Day5.Database.init(freshIDRanges:availableIDs:)) {
            ranges
            "\n\n"
            availableIDs
        }
    }
}
