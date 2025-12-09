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
        let rop = movableRollOfPaper(in: map)

        return rop.count
    }

    func movableRollOfPaper(in map: Map) -> [Point] {
        (0..<map.maxIndex)
            .map {
                let coordinates = map.convertIndexToCoordinates($0)

                return (coordinates, numberOfAdjacentRollOfPaper(at: coordinates, in: map))
            }
            .filter { map.isRollOfPaper(at: $0.0) && $0.1 < 4 }
            .map(\.0)
    }

    func numberOfAdjacentRollOfPaper(at coordinates: Point, in map: Map) -> Int {
        let offsets: [Point] = [
            .init(x: -1, y: -1), .init(x: 0, y: -1), .init(x: 1, y: -1),
            .init(x: -1, y: 0), .init(x: 1, y: 0),
            .init(x: -1, y: +1), .init(x: 0, y: +1), .init(x: 1, y: +1),
        ]

        return offsets
            .compactMap { map.coordinates(coordinates, offsetBy: $0) }
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

    func isInBounds(_ coordinates: Day4.Point) -> Bool {
        coordinates.x >= 0 && coordinates.x < size.width &&
        coordinates.y >= 0 && coordinates.y < size.height
    }

    func coordinates(_ coordinates: Day4.Point, offsetBy offset: Day4.Point) -> Day4.Point? {
        let newPoint = Day4.Point(
            x: coordinates.x + offset.x,
            y: coordinates.y + offset.y
        )

        guard isInBounds(newPoint) else { return nil }

        return newPoint
    }
}
