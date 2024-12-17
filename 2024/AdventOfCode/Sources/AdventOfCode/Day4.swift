import Foundation
import Parsing

struct Day4: Challenge {
    struct Matrix {
        let rows: Int
        let columns: Int

        let m: [[Substring]]

        init(matrix: [[Substring]]) {
            self.m = matrix
            self.rows = matrix.count
            self.columns = matrix.first?.count ?? 0
        }
    }

    enum Direction {
        case north, east, south, west

        var updateIndex: (Int, Int, Int) -> (Int, Int) {
            switch self {
            case .north:
                return { posX, posY, offset in (posX, posY - offset) }
            case .east:
                return { posX, posY, offset in (posX + offset, posY) }
            case .south:
                return { posX, posY, offset in (posX, posY + offset) }
            case .west:
                return { posX, posY, offset in (posX - offset, posY) }
            }
        }
    }

    var useExampleInput: Bool {
        false
    }

    func execute(
        withInput input: String,
        log: (String, Any?) -> Void
    ) async throws {
        log("Day 4", fileName)

        let lines = input
            .split(separator: "\n")
            .map { $0.split(separator: "") }
        let matrix = Matrix(matrix: lines)

        let wordToFind = "MAS"
        var foundCount = 0

        for y in (0..<matrix.rows) {
            for x in (0..<matrix.columns) {
                if lines[y][x] == "A" {
                    if let word1 = getWord(for: [.north, .east], length: wordToFind.count, from: matrix, posX: x, posY: y),
                       let word2 = getWord(for: [.north, .west], length: wordToFind.count, from: matrix, posX: x, posY: y) {
                        if word1 == wordToFind && word2 == wordToFind ||
                            word1 == wordToFind && String(word2.reversed()) == wordToFind ||
                            String(word1.reversed()) == wordToFind && word2 == wordToFind ||
                            String(word1.reversed()) == wordToFind && String(word2.reversed()) == wordToFind {
                            foundCount += 1
                        }
                    }
                }
            }
        }

        print("Found matches", foundCount)
    }

    func getWord(for directions: [Direction], length: Int, from matrix: Matrix, posX: Int, posY: Int) -> String? {
        getWord(from: matrix, posX: posX, posY: posY, updateOffsets: { posX, posY, offset in
            directions
                .reduce(into: (posX, posY)) { pos, direction in
                    pos = direction.updateIndex(pos.0, pos.1, offset)
                }
        })
    }

    func getWord(for direction: Direction, from matrix: Matrix, posX: Int, posY: Int) -> String? {
        getWord(from: matrix, posX: posX, posY: posY, updateOffsets: direction.updateIndex)
    }

    func getWord(from matrix: Matrix, posX: Int, posY: Int, updateOffsets: (Int, Int, Int) -> (Int, Int)) -> String? {
        do {
            struct EarlyStop: Error {}

            return try [-1, 0, 1]
                .reduce(into: "") { word, offset in
                    let (newX, newY) = updateOffsets(posX, posY, offset)

                    if newY >= matrix.rows || newX >= matrix.columns || newY < 0 || newX < 0 {
                        throw EarlyStop()
                    }

                    word += matrix.m[newY][newX]
                }
        } catch {
            return nil
        }
    }
}
