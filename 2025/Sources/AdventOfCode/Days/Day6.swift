import Parsing
import Foundation

struct Day6 {
    let identifier = "Day6"

    enum Operator {
        case multiply
        case add

        var run: (Int, Int) -> Int {
            switch self {
            case .add: { $0 + $1 }
            case .multiply: { $0 * $1 }
            }
        }

        var initialValue: Int {
            switch self {
            case .add: 0
            case .multiply: 1
            }
        }
    }

    struct Worksheet: Equatable {
        let values: [[Int]]
        let operations: [Operator]
    }

    func run(from filePath: URL) throws -> Int {
        let inputText = try String(contentsOf: filePath, encoding: .utf8)
        let worksheet = try parseInput(inputText)

        return worksheet.runOperations()
            .reduce(0, +)
    }

    func parseInput(_ input: String) throws -> Worksheet {
        try ParsableWorksheet().parse(input)
    }
}

extension Day6.Worksheet {
    func runOperations() -> [Int] {
        (0..<operations.count)
            .map { runOperation(at: $0) }
    }

    func runOperation(at index: Int) -> Int {
        let operation = operations[index]

        return values.reduce(operation.initialValue) { result, row in
            operation.run(result, row[index])
        }
    }
}

struct ParsableWorksheet: Parser {
    var valuesRow: some Parser<Substring, [Int]> {
        Parse {
            Whitespace(.horizontal)

            Many {
                Int.parser()
            } separator: {
                Whitespace(.horizontal)
            }

            Whitespace(.horizontal)
        }
    }

    var operatorsRow: some Parser<Substring, [Day6.Operator]> {
        Parse {
            Whitespace(.horizontal)

            Many {
                OneOf {
                    "*".map { Day6.Operator.multiply }
                    "+".map { Day6.Operator.add }
                }
            } separator: {
                Whitespace(.horizontal)
            }

            Whitespace(.horizontal)
        }
    }

    var body: some Parser<Substring, Day6.Worksheet> {
        Parse(Day6.Worksheet.init(values:operations:)) {
            Many(4) {
                valuesRow
            } separator: {
                Whitespace(.vertical)
            }

            Whitespace(1, .vertical)

            operatorsRow

            Whitespace()
        }
    }
}
