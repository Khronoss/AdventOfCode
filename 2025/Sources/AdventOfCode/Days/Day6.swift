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

        static func from(_ char: Character) -> Self? {
            switch char {
            case "+": return .add
            case "*": return .multiply
            default: return nil
            }
        }
    }

    struct Worksheet: Equatable {
        var values: [[Int]] = []
        var operations: [Operator] = []
    }

    func run(from filePath: URL) throws -> Int {
        let inputText = try String(contentsOf: filePath, encoding: .utf8)
        let worksheet = try parseInput(inputText)

        return worksheet.runOperations()
    }

    func parseInput(_ input: String) throws -> Worksheet {
        let lines = input.split(separator: "\n")
        let maxColumn = lines.map(\.count).max()!
        let operationIndex = lines.count - 1

        return (0..<maxColumn).reduce(into: Worksheet()) { worksheet, index in
            if let operation = Operator.from(lines[operationIndex].atIndex(index)) {
                worksheet.operations.append(operation)
                worksheet.values.append([])
            }

            let numberStr = (0..<operationIndex).reduce("") { partialResult, rowIndex in
                guard lines[rowIndex].count > index else { return partialResult }

                return partialResult + String(lines[rowIndex].atIndex(index))
            }.trimmingCharacters(in: .whitespaces)
            if numberStr.isEmpty { return }

            let number = Int(numberStr)!

            if var newValues = worksheet.values.popLast() {
                newValues.append(number)
                worksheet.values.append(newValues)
            }
        }
    }
}

extension Day6.Worksheet {
    func runOperations() -> Int {
        (0..<operations.count)
            .map { runOperation(at: $0) }
            .reduce(0, +)
    }

    func runOperation(at index: Int) -> Int {
        let operation = operations[index]

        return values[index].reduce(operation.initialValue) { result, value in
            operation.run(result, value)
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

extension StringProtocol {
    func atIndex(_ index: Int) -> Character {
        self[self.index(self.startIndex, offsetBy: index)]
    }
}
