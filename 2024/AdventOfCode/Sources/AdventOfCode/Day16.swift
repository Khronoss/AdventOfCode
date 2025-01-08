import Foundation
import AOCTools

struct Day16: Challenge {
    var useExampleInput: Bool {
        true
    }

    func execute(
        withInput input: String,
        log: (String, Any?) -> Void
    ) async throws {
        log("Day 16", nil)

        let map = Map(from: input)
        log("Map", nil)
        log(map.description, nil)

        let sortedPaths = map.allPathsFromStartToEnd().sorted(by: { $0.score < $1.score })
        let bestPath = sortedPaths.first!
//        let allBestPaths = sortedPaths.filter { $0.score == bestPath.score }

        print("Score", bestPath.score)
    }

    struct Position: Hashable {
        let x: Int
        let y: Int

        static var up: Position { .init(x: 0, y: -1) }
        static var down: Position { .init(x: 0, y: 1) }
        static var left: Position { .init(x: -1, y: 0) }
        static var right: Position { .init(x: 1, y: 0) }

        static var allDirections: [Position] { [up, down, left, right] }

        func adding(_ other: Self) -> Self {
            .init(x: x + other.x, y: y + other.y)
        }

        var up: Self { adding(.up) }
        var left: Self { adding(.left) }
        var down: Self { adding(.down) }
        var right: Self { adding(.right) }
    }

    struct Path {
        let lastPosition: Position
        let heading: Position
        let score: Int

        func adding(_ position: Position, heading: Position) -> Self {
            let moveCost = if self.heading == heading {
                1
            } else { //turn
                1001
            }

            return .init(
                lastPosition: position,
                heading: heading,
                score: score + moveCost
            )
        }
    }

    struct Map: CustomStringConvertible {
        enum Cell: Character {
            case wall = "#"
            case sart = "S"
            case end = "E"
            case empty = "."
        }

        let cells: [[Cell]]

        init(from input: some StringProtocol) {
            cells = input
                .split(separator: "\n")
                .map { line in
                    line.map { Cell(rawValue: $0) ?? .wall }
                }
        }

        func allPathsFromStartToEnd() -> [Path] {
            guard let startPosition, let endPosition else { return [] }

            return allPaths(from: startPosition, to: endPosition)
        }

        func allPaths(from startPosition: Position, to endPosition: Position) -> [Path] {
            let startPath = Path(lastPosition: startPosition, heading: .right, score: 0)
            var queue = PriorityQueue<Path>(comparator: { $0.score < $1.score })
            var visitedCells: Set<Position> = []
            queue.insert(startPath)

            while queue.count > 0 {
                let currentPath = queue.pop()!
                visitedCells.insert(currentPath.lastPosition)

                let possibleDirections = Position.allDirections
                    .filter { // No half-turn
                        currentPath.heading.adding($0) != .init(x: 0, y: 0)
                    }

                for direction in possibleDirections {
                    let nextPosition = currentPath.lastPosition.adding(direction)
                    let nextCell = getCell(at: nextPosition)

                    guard nextCell != .wall else { continue }

                    if nextPosition != endPosition && !visitedCells.contains(nextPosition) {
                        queue.insert(currentPath.adding(nextPosition, heading: direction))
                    } else if nextPosition == endPosition {
                        let finalPath = currentPath.adding(nextPosition, heading: direction)
                        return [finalPath]
                    }
                }
            }

            return []
        }

        func getCell(at position: Position) -> Cell {
            cells[position.y][position.x]
        }

        var endPosition: Position? {
            firstPosition(of: .end)
        }

        var startPosition: Position? {
            firstPosition(of: .sart)
        }

        func firstPosition(of cell: Cell) -> Position? {
            guard
                let yPos = cells.firstIndex(where: { $0.contains(cell) }),
                let xPos = cells[yPos].firstIndex(of: cell)
            else { return nil }

            return .init(x: xPos, y: yPos)
        }

        var description: String {
            cells
                .map { String($0.map(\.rawValue)) }
                .joined(separator: "\n")
        }
    }
}
