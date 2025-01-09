import Foundation
import Parsing

struct Day18: Challenge {
    var useExampleInput: Bool {
        false
    }

    func execute(
        withInput input: String,
        log: (String, Any?) -> Void
    ) async throws {
        log("Day 18", nil)

        let bytes = try PositionsParser().parse(input)
        let gridSize = useExampleInput ? 7 : 71
        let start = Position(x: 0, y: 0)
        let end = useExampleInput ? Position(x: 6, y: 6) : Position(x: 70, y: 70)

        var bSearchStep = 0
        var searchIndex = 0
        var searchDirection = 1
        var found = false

        while !found {
            bSearchStep += 1
            let bSearchOffset = (bytes.count / intPow(2, bSearchStep)) + 1
            searchIndex += bSearchOffset * searchDirection

            log("Simulating falling bytes...", searchIndex)
            let fallingBytes = Array(bytes.prefix(through: searchIndex - 1))


            var grid = Grid(size: gridSize, bytes: fallingBytes)


            let path = grid.shortestPath(from: start, to: end)

            if path.isEmpty {
                log("Path is blocked!", nil)
                searchDirection = -1
                if bSearchOffset == 1 {
                    found = true
                }
            } else {
                log("Path isn't blocked", nil)
                searchDirection = 1
            }
        }

        log("Found blocking byte index", searchIndex)
        log("Byte", bytes[searchIndex - 1])
    }

    struct Grid {
        typealias Cell = Int

        var cells: [[Cell]]
        let size: Int

        init(size: Int, bytes: [Position]) {
            self.size = size
            self.cells = (0..<size).map { y in
                (0..<size).map { x in
                    let position = Position(x: x, y: y)

                    if bytes.contains(position) {
                        return Int.max
                    } else {
                        return 0
                    }
                }
            }
        }

        mutating
        func shortestPath(from start: Position, to end: Position) -> [Position] {
            var queue: [Position] = [start]

            cells[start.y][start.x] = 1

            // process cells scores with BFS
            while !queue.isEmpty {
                let lastPosition = queue.removeFirst()

                [Position.right, .down, .left, .up].forEach { direction in
                    let nextPos = lastPosition.adding(direction)

                    if !isOutOfBounds(nextPos) {
                        let cell = getCell(at: lastPosition)
                        let nextCell = getCell(at: nextPos)
                        let nextCellScore = cell + 1

                        if nextCell != Int.max && (nextCell > nextCellScore || nextCell == 0) {
                            cells[nextPos.y][nextPos.x] = nextCellScore
                            queue.append(nextPos)
                        }
                    }
                }
            }

            // Path is blocked!
            if getCell(at: end) == 0 {
                return []
            }

            // get back lowest score path
            var path: [Position] = []
            var currentPosition = end

            while currentPosition != start {
                let possibleDirections = [Position.right, .down, .left, .up]
                    .filter { !isOutOfBounds(currentPosition.adding($0)) }

                let nextPosition = possibleDirections
                    .reduce(currentPosition.adding(possibleDirections.first!)) { lowest, direction in
                        let nextPos = currentPosition.adding(direction)

                        guard !isOutOfBounds(nextPos) else { return lowest }

                        let lowestCell = getCell(at: lowest)
                        let nextCell = getCell(at: nextPos)

                        return nextCell < lowestCell ? nextPos : lowest
                    }

                currentPosition = nextPosition
                path.append(nextPosition)
            }

            return path.reversed()
        }

        func isOutOfBounds(_ position: Position) -> Bool {
            position.x < 0 || position.y < 0 ||
            position.x >= size || position.y >= size
        }

        func printMap(withPath path: [Position] = []) {
            let grid = (0..<size).map { y in
                (0..<size).map { x in
                    let position = Position(x: x, y: y)
                    let cell = getCell(at: position)

                    if cell == Int.max {
                        return "#"
                    } else if path.contains(position) {
                        return "O"
                    } else {
                        let chars = ".abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
                        return String(chars.getChar(at: cell % chars.count))
                    }
                }.joined()
            }

            print(grid.joined(separator: "\n"))
        }

        func getCell(at position: Position) -> Cell {
            cells[position.y][position.x]
        }
    }

    struct Position: Hashable {
        let x: Int
        let y: Int

        static var up: Position { .init(x: 0, y: -1) }
        static var down: Position { .init(x: 0, y: 1) }
        static var left: Position { .init(x: -1, y: 0) }
        static var right: Position { .init(x: 1, y: 0) }

        func adding(_ other: Self) -> Self {
            .init(x: x + other.x, y: y + other.y)
        }

        var up: Self { adding(.up) }
        var left: Self { adding(.left) }
        var down: Self { adding(.down) }
        var right: Self { adding(.right) }
    }

    struct PositionsParser: Parser {
        var body: some Parser<Substring, [Position]> {
            Many {
                PositionParser()
            } separator: {
                Whitespace(.vertical)
            }
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
}
