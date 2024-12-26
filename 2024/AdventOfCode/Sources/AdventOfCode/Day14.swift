import Foundation
import Parsing

struct Day14: Challenge {
    var useExampleInput: Bool {
        false
    }

    func execute(
        withInput input: String,
        log: (String, Any?) -> Void
    ) async throws {
        log("Day 14", nil)

//        let robots = [Robot(position: .init(x: 2, y: 4), velocity: .init(x: 2, y: -3))]
        let robots = try RobotsParser().parse(input)
        let grid: Position = useExampleInput ? .init(x: 11, y: 7) : .init(x: 101, y: 103)

//        printMap(positions: robots.map(\.position), grid: grid)
//        log("Robots positions", robots.map(\.position))
        log("Robots count", robots.count)

        for step in (0...10_000) {
            let newPositions = robots
                .map { $0.positionAfter(steps: step, grid: grid) }

            let quads = getCountByQuadrant(newPositions, grid: grid)

            let maxQuad = max(quads.0, max(quads.1, max(quads.2, quads.3)))
            let minQuad = min(quads.0, min(quads.1, min(quads.2, quads.3)))
            if maxQuad - minQuad > 200 {
                log("Possible solution", step)
                printMap(positions: newPositions, grid: grid)
            }
//        log("Quads", counts)
//
//        log("Safety score", counts.0 * counts.1 * counts.2 * counts.3)
        }
    }

    func getCountByQuadrant(_ positions: [Position], grid: Position) -> (Int, Int, Int, Int) {
        let midX = grid.x / 2
        let midY = grid.y / 2

        return positions
            .reduce(into: (0, 0, 0, 0)) { quadrants, position in // top-left, top-right, bot-left, bot-right
                if position.x < midX && position.y < midY {
                    quadrants.0 += 1
                } else if position.x > midX && position.y < midY {
                    quadrants.1 += 1
                } else if position.x < midX && position.y > midY {
                    quadrants.2 += 1
                } else if position.x > midX && position.y > midY {
                    quadrants.3 += 1
                }
            }
    }

    func printMap(positions: [Position], grid: Position) {
        (0..<grid.y).forEach { y in
            let row = (0..<grid.x).map { x in
                let position = Position(x: x, y: y)
                let count = positions.count { $0 == position }

                return count == 0 ? "." : String(count)
            }

            print(row.joined())
        }
    }

    struct Position: Equatable, CustomStringConvertible {
        let x: Int
        let y: Int

        var description: String {
            "{\(x), \(y)}"
        }

        static func *(lhs: Self, rhs: Int) -> Self {
            .init(x: lhs.x * rhs, y: lhs.y * rhs)
        }

        static func +(lhs: Self, rhs: Self) -> Self {
            .init(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
        }

        static func %(lhs: Self, rhs: Self) -> Self {
            var newX = lhs.x % rhs.x
            if lhs.x < 0 && newX != 0 {
                newX = rhs.x + newX
            }
            var newY = lhs.y % rhs.y
            if lhs.y < 0 && newY != 0 {
                newY = rhs.y + newY
            }

            return .init(x: newX, y: newY)
        }
    }

    struct Robot: Equatable {
        let position: Position
        let velocity: Position

        func positionAfter(steps: Int, grid: Position) -> Position {
            (position + velocity * steps) % grid
        }
    }

    struct PositionParser: Parser {
        var body: some Parser<Substring, Position> {
            Parse(Position.init) {
                Int.parser()
                ","
                Int.parser()
            }
        }
    }

    struct RobotParser: Parser {
        var body: some Parser<Substring, Robot> {
            Parse(Robot.init) {
                "p="
                PositionParser()
                " v="
                PositionParser()
            }
        }
    }

    struct RobotsParser: Parser {
        var body: some Parser<Substring, [Robot]> {
            Many {
                RobotParser()
            } separator: {
                Whitespace(.vertical)
            }
        }
    }
}
