import Foundation

struct Day15: Challenge {
    var useExampleInput: Bool {
        false
    }

    func execute(
        withInput input: String,
        log: (String, Any?) -> Void
    ) async throws {
        log("Day 15", nil)

        let inputs = input
            .replacingOccurrences(of: "#", with: "##")
            .replacingOccurrences(of: "O", with: "[]")
            .replacingOccurrences(of: ".", with: "..")
            .replacingOccurrences(of: "@", with: "@.")
            .split(separator: "\n\n")
//        log("Inputs", inputs)

        var map = Map(from: inputs[0])
        log("Map", nil)
        log(map.description, nil)

        let directions = inputs[1].map(String.init).joined()
        log("Directions", directions)

        directions
            .compactMap(Position.from(input:))
            .forEach { map.moveRobot($0) }
        log("Map", nil)
        log(map.description, nil)

        log("Distances", map.allBoxesDistances().reduce(0, +))
    }

    struct Position: Hashable {
        let x: Int
        let y: Int

        static var up: Position { .init(x: 0, y: -1) }
        static var down: Position { .init(x: 0, y: 1) }
        static var left: Position { .init(x: -1, y: 0) }
        static var right: Position { .init(x: 1, y: 0) }

        static func from(input: Character) -> Self? {
            switch input {
            case "^": .up
            case ">": .right
            case "v": .down
            case "<": .left
            default: nil
            }
        }

        func adding(_ other: Self) -> Self {
            .init(x: x + other.x, y: y + other.y)
        }

        var isVertical: Bool {
            self == .up || self == .down
        }
    }

    struct Map: CustomStringConvertible {
        enum Cell: Character {
            case wall = "#"
            case boxLeft = "["
            case boxRight = "]"
            case robot = "@"
            case empty = "."

            var isBox: Bool {
                self == .boxLeft || self == .boxRight
            }
        }

        var cells: [[Cell]]

        init(from input: some StringProtocol) {
            cells = input
                .split(separator: "\n")
                .map { line in
                    line.map { Cell.init(rawValue: $0) ?? .empty }
                }
        }

        mutating func moveCell(at position: Position, direction: Position) {
            let nextCell = position.adding(direction)

            switch getCell(at: nextCell) {
            case .empty:
                cells[nextCell.y][nextCell.x] = cells[position.y][position.x]
                cells[position.y][position.x] = .empty
            case .boxLeft:
                moveCell(at: nextCell, direction: direction)
                if direction.isVertical {
                    moveCell(at: nextCell.adding(.right), direction: direction)
                }
                cells[nextCell.y][nextCell.x] = cells[position.y][position.x]
                cells[position.y][position.x] = .empty
            case .boxRight:
                moveCell(at: nextCell, direction: direction)
                if direction.isVertical {
                    moveCell(at: nextCell.adding(.left), direction: direction)
                }
                cells[nextCell.y][nextCell.x] = cells[position.y][position.x]
                cells[position.y][position.x] = .empty
            case .robot, .wall:
                break
            }
        }

        func canMoveCell(at position: Position, direction: Position) -> Bool {
            let nextCell = position.adding(direction)

            if direction.isVertical && getCell(at: nextCell).isBox {
                let otherBoxSide = if getCell(at: nextCell) == .boxLeft {
                    nextCell.adding(.right)
                } else {
                    nextCell.adding(.left)
                }

                return canMoveCell(at: nextCell, direction: direction) &&
                canMoveCell(at: otherBoxSide, direction: direction)
            }

            switch getCell(at: nextCell) {
            case .empty:
                return true
            case .boxLeft:
                return canMoveCell(at: nextCell, direction: direction)
            case .boxRight:
                return canMoveCell(at: nextCell, direction: direction)
            case .robot, .wall:
                return false
            }
        }

        mutating func moveRobot(_ direction: Position) {
            guard let robotPos = robotPosition() else { return }

            if canMoveCell(at: robotPos, direction: direction) {
                moveCell(at: robotPos, direction: direction)
            }
        }

        func robotPosition() -> Position? {
            guard
                let yPos = cells.firstIndex(where: { $0.contains(.robot) }),
                let xPos = cells[yPos].firstIndex(of: .robot)
            else { return nil }

            return .init(x: xPos, y: yPos)
        }

        func allBoxesDistances() -> [Int] {
            var distances: [Int] = []

            for y in (0..<cells.count) {
                let line = cells[y]
                for x in (0..<cells[y].count) {
                    if line[x] == .boxLeft {
                        distances.append(100 * y + x)
                    }
                }
            }

            return distances
        }

        func getCell(at position: Position) -> Cell {
            cells[position.y][position.x]
        }

        var description: String {
            cells
                .map { String($0.map(\.rawValue)) }
                .joined(separator: "\n")
        }
    }
}
