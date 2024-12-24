import Foundation
import Parsing

struct Day13: Challenge {
    var useExampleInput: Bool {
        false
    }

    func execute(
        withInput input: String,
        log: (String, Any?) -> Void
    ) async throws {
        log("Day 13", nil)

        let clawMachines = try ManyClawMachineParser().parse(input)

        let cost = totalCost(moves: clawMachines.map { $0.getOptimalMoves() })
        log("Total cost", cost)
    }

    func totalCost(moves: [(A: Int, B: Int)]) -> Int {
        moves.reduce(0) { partialResult, move in
            partialResult + (move.A * 3) + (move.B * 1)
        }
    }

    struct Position: Equatable {
        let x: Int
        let y: Int
    }

    struct ClawMachine: Equatable {
        struct Button: Equatable {
            let move: Position
        }

        let btnA: Button
        let btnB: Button
        let prize: Position

        init(btnA: Button, btnB: Button, prize: Position) {
            self.btnA = btnA
            self.btnB = btnB

            let prizeOffset = 10_000_000_000_000
            self.prize = .init(x: prizeOffset + prize.x, y: prizeOffset + prize.y)
        }

        func getOptimalMoves() -> (A: Int, B: Int) {
            // Cramer's Rule
            let divisor = btnA.move.x * btnB.move.y - btnA.move.y * btnB.move.x
            let A = (prize.x * btnB.move.y - prize.y * btnB.move.x) / divisor
            let B = (prize.y * btnA.move.x - prize.x * btnA.move.y) / divisor

            guard
                A*btnA.move.x + B*btnB.move.x == prize.x,
                A*btnA.move.y + B*btnB.move.y == prize.y
            else {
                return (0, 0)
            }

            return (A, B)
        }
    }

    struct PrizeParser: Parser {
        var body: some Parser<Substring, Position> {
            Parse(Position.init) {
                "X="
                Int.parser()
                ", Y="
                Int.parser()
            }
        }
    }

    struct ButtonParser: Parser {
        var body: some Parser<Substring, ClawMachine.Button> {
            Parse {
                ClawMachine.Button(move: Position(x: $0.0, y: $0.1))
            } with: {
                "X+"
                Int.parser()
                ", Y+"
                Int.parser()
            }
        }
    }

    struct ClawMachineParser: Parser {
        var body: some Parser<Substring, ClawMachine> {
            Parse(ClawMachine.init) {
                "Button A: "
                ButtonParser()
                "\nButton B: "
                ButtonParser()
                "\nPrize: "
                PrizeParser()
            }
        }
    }

    struct ManyClawMachineParser: Parser {
        var body: some Parser<Substring, [ClawMachine]> {
            Many {
                ClawMachineParser()
                Whitespace(.vertical)
            }
        }
    }
}
