import Parsing
import Foundation

struct Day2 {
    let identifier = "Day2"

    var rangeParser: some Parser<Substring, ClosedRange<Int>> {
        Parse {
            $0...$1
        } with: {
            Int.parser()
            "-"
            Int.parser()
        }
    }

    var rangesParser: some Parser<Substring, [ClosedRange<Int>]> {
        Many {
            rangeParser
        } separator: {
            ","
        }
    }

    func run(from filePath: URL) throws -> Int {
        addAllInvalidIDs(from: try parseInput(from: filePath))
    }

    func parseInput(from filePath: URL) throws -> [ClosedRange<Int>] {
        let inputText = try String(contentsOf: filePath, encoding: .utf8)

        return try rangesOfIDs(from: String(inputText.dropLast()))
    }

    func rangesOfIDs(from input: String) throws -> [ClosedRange<Int>] {
        try rangesParser.parse(input)
    }

    func addAllInvalidIDs(from ranges: [ClosedRange<Int>]) -> Int {
        ranges
            .flatMap(findInvalidIDs(for:))
            .reduce(0, +)
    }

    func findInvalidIDs(for range: ClosedRange<Int>) -> [Int] {
        range.filter { $0.isRepeating() }
    }
}

extension Int {
    func isRepeatingTwice() -> Bool {
        let half = Int(round(Double(self.digitsCount()) / 2))
        return isRepeating(sequenceLength: half)
    }

    func isRepeating() -> Bool {
        let half = Int(round(Double(self.digitsCount()) / 2))
        return (1...half).contains(where: { sequenceLength in
            isRepeating(sequenceLength: sequenceLength)
        })
    }

    func isRepeating(sequenceLength seqLength: Int) -> Bool {
        let length = digitsCount()
        let divisor = pow(10, seqLength).toInt()
        let pattern = self % divisor
        let repeated = (1...length/seqLength).reduce(0) { acc, _ in
            acc * divisor + pattern
        }
        return self == repeated
    }

    func digitsCount() -> Int {
        Int(floor(log10(Double(self))) + 1)
    }
}

extension Decimal {
    func toInt() -> Int {
        NSDecimalNumber(decimal: self).intValue
    }
}
