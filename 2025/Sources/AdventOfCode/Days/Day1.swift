import Foundation
import Parsing

struct Day1 {
    struct Step: Equatable {
        enum Direction: Equatable {
            case left, right

            var sign: Int {
                switch self {
                case .left: -1
                case .right: +1
                }
            }
        }

        let direction: Direction
        let distance: Int

        static func left(_ value: Int) -> Self {
            .init(direction: .left, distance: value)
        }

        static func right(_ value: Int) -> Self {
            .init(direction: .right, distance: value)
        }

        var signedDistance: Int {
            switch direction {
            case .left: -distance
            case .right: distance
            }
        }
    }

    let identifier = "Day1"
    let initialDialValue = 50

    func run(from filePath: URL) throws -> Int {
        let steps = try parseInput(from: filePath)

        return numberOf(0, forSteps: steps)
    }

    func parseInput(from filePath: URL) throws -> [Step] {
        let inputText = try String(contentsOf: filePath, encoding: .utf8)

        return try ParsableStep().parse(inputText.dropLast())
    }

    func numberOf(_ stopValue: Int, forSteps steps: [Step]) -> Int {
        steps.reduce((initialDialValue, 0)) { partialResult, step in
            let currentValue = partialResult.0
            let newValue = nextValue(forStep: step, currentValue: currentValue)

            let fullRotations = step.distance / 100
            let passByZero = switch step.direction {
            case .left: newValue > currentValue
            case .right: newValue < currentValue
            }
            let newCount = partialResult.1 + fullRotations + (passByZero ? 1 : 0)

            return (newValue, newCount)
        }
        .1
    }

    func nextValue(forStep step: Step, currentValue: Int) -> Int {
        (currentValue + step.signedDistance).mod(100)
    }
}

extension BinaryInteger {
    func mod(_ modulo: Self) -> Self {
        let rem = self % modulo // -modulo <= rem <= modulo
        return rem >= 0 ? rem : rem + modulo
    }
}


extension Day1 {
    struct ParsableStep: Parser {
        let step = Parse(Day1.Step.init(direction:distance:)) {
            OneOf {
                "L".map { Day1.Step.Direction.left }
                "R".map { Day1.Step.Direction.right }
            }
            Int.parser()
        }

        var body: some Parser<Substring, [Step]> {
            Many {
                step
            } separator: {
                "\n"
            }
        }
    }
}
