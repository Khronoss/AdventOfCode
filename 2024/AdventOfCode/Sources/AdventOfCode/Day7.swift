import Foundation
import Parsing

struct Day7: Challenge {
    var useExampleInput: Bool {
        false
    }

    func execute(
        withInput input: String,
        log: (String, Any?) -> Void
    ) async throws {
        log("Day7", nil)

        let equations = try parser.parse(input)

        let sum = equations
            .compactMap { equation in
                let results = process(input: equation.factors)

                if let result = results.first(where: { $0 == equation.testValue }) {
                    return result
                } else {
                    return nil
                }
            }
            .reduce(0, +)

        print(equations.map(\.description).joined(separator: "\n"))
        print("Sum:", sum)
    }

    func process(input: [Int]) -> [Int] {
        guard input.count > 1 else {
            return input
        }

        let head = input.last!
        let tail = Array(input[..<(input.count-1)])

        return process(input: tail)
            .flatMap {
                [
                    $0 + head,
                    $0 * head,
                    Self.concat($0, head)
                ]
            }
    }

    static func concat(_ lhs: Int, _ rhs: Int) -> Int {
        Int("\(lhs)\(rhs)")!
    }

    let parser: some Parser<Substring, [Equation]> = Many {
        EquationParser()
    } separator: {
        "\n"
    }


    struct Equation: Equatable, CustomStringConvertible {
        let testValue: Int
        let factors: [Int]

        var description: String {
            [testValue: factors].description
        }
    }

    struct EquationParser: Parser {
        var body: some Parser<Substring, Equation> {
            Parse(Equation.init) {
                Int.parser()
                ":"
                Whitespace()

                FactorsParser()
            }
        }
    }

    struct FactorsParser: Parser {
        var body: some Parser<Substring, [Int]> {
            Many {
                Int.parser()
            } separator: {
                Whitespace(.horizontal)
            }
        }
    }
}
