import Foundation

struct Day10: Challenge {
    var useExampleInput: Bool {
        false
    }

    func execute(
        withInput input: String,
        log: (String, Any?) -> Void
    ) async throws {
        log("Day10", nil)

        let map = Map(input)
        log("Map", map)

        let startPoints = map
            .flatMapCells { cell in
                cell.value == 0 ? cell : nil
            }
            .compactMap { $0 }
        log("StartPoints", startPoints)
        log("StartPoints.count", startPoints.count)

        let uniqueTrails = startPoints
            .map { cell in
                hikingTrails(from: cell, in: map)
                    .compactMap(\.last)
            }
//            .map(Set.init)
            .map(\.count)
        log("Unique trails", uniqueTrails)
        log("Score", uniqueTrails.reduce(0, +))
    }

    func hikingTrails(from cell: Cell, in map: Map, hike: [Cell] = []) -> [[Cell]] {
        if cell.value == 9 { return [hike] }

        let results = map.neighboors(of: cell)
            .filter { $0.value == cell.value + 1 }
            .flatMap { cell in
                hikingTrails(from: cell, in: map, hike: hike + [cell])
            }

        return results
    }

    struct Cell: Hashable {
        let x: Int
        let y: Int
        let value: Int
    }

    struct Map: CustomStringConvertible {
        let width: Int
        let height: Int

        let cells: [[Int]]

        init(_ input: String) {
            let lines = input.split(separator: "\n")
            let height = lines.count
            let width = lines.first?.count ?? 0

            self.height = height
            self.width = width
            self.cells = (0..<height).map { y in
                let line = lines[y]

                return (0..<width).map { x in
                    Int(String(line[line.index(line.startIndex, offsetBy: x)]))!
                }
            }
        }

        var description: String {
            """
            {
                width: \(width), height: \(height),
                map: [
                    \(cells.map({ $0.map(String.init).joined(separator: " ") }).joined(separator: "\n\t\t"))
                ]
            }
            """
        }

        func flatMapCells<Value>(_ transform: (Cell) -> Value) -> [Value] {
            (0..<height).flatMap { y in
                let line = cells[y]

                return (0..<width).map { x in
                    let cell = Cell(x: x, y: y, value: line[x])

                    return transform(cell)
                }
            }
        }

        func neighboors(of cell: Cell) -> [Cell] {
            [(0, -1),(1, 0), (0, 1), (-1, 0)] // N, E, S, W
                .compactMap { offset in
                    let newX = cell.x + offset.0
                    let newY = cell.y + offset.1

                    guard !isOutOfBounds(x: newX, y: newY) else { return nil }

                    return Cell(x: newX, y: newY, value: cells[newY][newX])
                }
        }

        func isOutOfBounds(x: Int, y: Int) -> Bool {
            x < 0 || y < 0 || x >= width || y >= height
        }
    }
}
