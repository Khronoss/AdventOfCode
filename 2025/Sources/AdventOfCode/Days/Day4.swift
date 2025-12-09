import Parsing
import Foundation

struct Day4 {
    let identifier = "Day4"

    struct Size: Equatable {
        let width, height: Int
    }

    struct Point: Equatable {
        let x, y: Int
    }

    struct Map {
        let map: [Substring]
        let size: Size

        init(_ stringMap: String) {
            let map = stringMap.split(separator: "\n")

            self.map = map
            self.size = Size(width: map.first!.count, height: map.count)
        }
    }

    func run(from filePath: URL) throws -> Int {
        let content = try String(contentsOf: filePath, encoding: .utf8)
        let map = Map(content)

        return numberOfMovableRollOfPaper(in: map)
    }

    func numberOfMovableRollOfPaper(in map: Map) -> Int {
        movableRollOfPaper(in: map)
            .filter { $0 < 4 }
            .count
    }

    func movableRollOfPaper(in map: Map) -> [Int] {
        (0..<map.maxIndex)
            .map { numberOfAdjacentRollOfPaper(at: $0, in: map) }
    }

    func numberOfAdjacentRollOfPaper(at index: Int, in map: Map) -> Int {
        let coordinate = map.convertIndexToCoordinates(index)
        let offsets: [Point] = [
            .init(x: -1, y: -1), .init(x: 0, y: -1), .init(x: 1, y: -1),
            .init(x: -1, y: 0), .init(x: 1, y: 0),
            .init(x: -1, y: +1), .init(x: 0, y: +1), .init(x: 1, y: +1),
        ]

        return offsets
            .compactMap { map.coordinate(coordinate, offsetBy: $0) }
            .filter { map.isRollOfPaper(at: $0) }
            .count
    }
}

extension Day4.Map {
    var maxIndex: Int {
        size.width * size.height
    }

    func isRollOfPaper(at position: Day4.Point) -> Bool {
        let row = map[position.y]
        let char = row[row.index(row.startIndex, offsetBy: position.x)]

        return char == "@"
    }

    func convertIndexToCoordinates(_ index: Int) -> Day4.Point {
        guard index >= 0 && index < maxIndex else {
            preconditionFailure("Index out of bounds")
        }

        let row = index / size.width
        let colum = index % size.width

        return .init(x: colum, y: row)
    }

    func isInBounds(_ index: Int) -> Bool {
        index >= 0 && index < maxIndex
    }

    func isInBounds(_ coordinate: Day4.Point) -> Bool {
        coordinate.x >= 0 && coordinate.x < size.width &&
        coordinate.y >= 0 && coordinate.y < size.height
    }

    func coordinate(_ coordinate: Day4.Point, offsetBy offset: Day4.Point) -> Day4.Point? {
        let newPoint = Day4.Point(
            x: coordinate.x + offset.x,
            y: coordinate.y + offset.y
        )

        guard isInBounds(newPoint) else { return nil }

        return newPoint
    }
}
