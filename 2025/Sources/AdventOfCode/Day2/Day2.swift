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
        let invalidIDs = allInvalidIDs(from: testingRange(from: range))

        return invalidIDs.filter { range.contains($0) }
    }

    func allInvalidIDs(from testingPoint: ClosedRange<Int>) -> [Int] {
        testingPoint.map { value in
            "\(value)".repeatedTwice().toInt
        }
    }

    func testingRange(from range: ClosedRange<Int>) -> ClosedRange<Int> {
        let lowerBound = lowestTestingPoint(for: range)
        let upperBound = highestTestingPoint(for: range)

        return lowerBound...upperBound
    }

    func lowestTestingPoint(for range: ClosedRange<Int>) -> Int {
        testingPoint(for: range.lowerBound)
    }

    func highestTestingPoint(for range: ClosedRange<Int>) -> Int {
        testingPoint(for: range.upperBound, roundedUp: true)
    }

    func testingPoint(for value: Int, roundedUp: Bool = false) -> Int {
        let half = "\(value)"
            .firstHalf(roundedUp: roundedUp)

        guard !half.isEmpty else { return 1 }

        return half.toInt
    }
}

extension StringProtocol {
    var toInt: Int {
        guard let result = Int(self) else {
            fatalError("Could not parse value: \(self)")
        }
        return result
    }

    func firstHalf(roundedUp: Bool) -> Self.SubSequence {
        let size = if roundedUp {
            Int(ceil(Double(self.count) / 2))
        } else {
            self.count / 2
        }

        return getSubSequence(ofLength: size, atOffset: 0)

        func getSubSequence(ofLength length: Int, atOffset offset: Int) -> Self.SubSequence {
            let startIndex = self.index(self.startIndex, offsetBy: offset * length)
            let endIndex = self.index(self.startIndex, offsetBy: (offset + 1) * length)

            return self[startIndex..<endIndex]
        }
    }

    func repeatedTwice() -> String {
        String(repeating: String(self), count: 2)
    }
}
