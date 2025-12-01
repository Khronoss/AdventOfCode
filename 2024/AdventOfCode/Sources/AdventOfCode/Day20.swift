import Foundation
import Parsing
import AOCTools

struct Day20: Challenge {
    var useExampleInput: Bool {
        false
    }

    func execute(
        withInput input: String,
        log: (String, Any?) -> Void
    ) async throws {
        log("Day 20", nil)

        let map = Grid(input: input)

        let track = map.getTrack()
        let baseTime = track.count - 1
        log("Base track time", baseTime)

        let times = allCheatTimes(forTrack: track)
            .map { baseTime - $0 }
            .filter { useExampleInput ? true : $0 >= 100 }

        log("Times", times.sorted())
        log("Times count", times.count)
    }

    func allCheatTimes(forTrack track: Track, cheatLength: Int = 2) -> [Int] {
        var times: [Int] = []
        let baseTime = track.count - 1
        let trackSet = Set(track.keys)
        var indices: [Position: Int] = [:]

        for (step, i) in track {
            let startCheat = step

            for cheatIdx in (1..<cheatLength) {

            }
            for direction in Position.allDirections {
                let midPos = startCheat.adding(direction)
                let endCheat = startCheat.adding(direction.scaled(by: cheatLength))

                if !trackSet.contains(midPos), let endCheatIdx = track[endCheat], endCheatIdx > i {
                    times.append(baseTime - (endCheatIdx - i) + cheatLength)
                    indices[endCheat] = endCheatIdx
                }
            }
        }

        return times
    }

    typealias Track = [Position: Int]

    struct Position: Hashable {
        let x: Int
        let y: Int

        static var up: Position { .init(x: 0, y: -1) }
        static var down: Position { .init(x: 0, y: 1) }
        static var left: Position { .init(x: -1, y: 0) }
        static var right: Position { .init(x: 1, y: 0) }
        static var allDirections: [Self] { [.up, .right, .down, .left] }

        func adding(_ other: Self) -> Self {
            .init(x: x + other.x, y: y + other.y)
        }

        func scaled(by scalar: Int) -> Self {
            .init(x: x * scalar, y: y * scalar)
        }

        var up: Self { adding(.up) }
        var left: Self { adding(.left) }
        var down: Self { adding(.down) }
        var right: Self { adding(.right) }
    }

    struct Grid {
        typealias Cell = Character

        let size: Position
        let cells: [[Cell]]

        let start: Position
        let end: Position

        func getTrack() -> Track {
            var stack: [Position] = [start]
            var currentPosition = start

            while currentPosition != end {
                let direction = Position.allDirections
                    .first { direction in
                        let nextStep = currentPosition.adding(direction)
                        let isSteppingBack = stack.count > 1 && nextStep == stack[stack.count - 2]
                        return canMove(to: nextStep) && !isSteppingBack
                    }

                if let direction {
                    let nextStep = currentPosition.adding(direction)
                    stack.append(nextStep)
                    currentPosition = nextStep
                }
            }

            return (0..<stack.count).reduce(into: Track()) { track, idx in
                track[stack[idx]] = idx
            }
        }

        func canMove(to position: Position) -> Bool {
            !isOutOfBounds(position) && cells[position.y][position.x] != "#"
        }

        func isOutOfBounds(_ position: Position) -> Bool {
            position.x < 0 || position.y < 0 || position.x >= size.x || position.y >= size.y
        }
    }
}

extension Day20.Grid {
    init(input: String) {
        let rows = input.split(separator: "\n")
        let height = rows.count
        let width = rows[0].count

        var start: Day20.Position?
        var end: Day20.Position?
        var cells: [[Cell]] = []

        for y in (0..<height) {
            let row = rows[y]
            var cellsRow: [Cell] = []
            for x in (0..<width) {
                let cell = row.getChar(at: x)

                if cell == "S" {
                    start = Day20.Position(x: x, y: y)
                    cellsRow.append(".")
                } else if cell == "E" {
                    end = Day20.Position(x: x, y: y)
                    cellsRow.append(".")
                } else {
                    cellsRow.append(cell)
                }
            }
            cells.append(cellsRow)
        }

        self.start = start!
        self.end = end!
        self.size = Day20.Position(x: width, y: height)
        self.cells = cells
    }
}
