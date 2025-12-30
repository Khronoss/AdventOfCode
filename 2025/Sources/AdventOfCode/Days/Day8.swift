import Parsing
import Foundation

struct Day8 {
    let identifier = "Day8"

    struct Point: Hashable {
        let x, y, z: Int

        init(x: Int, y: Int, z: Int) {
            self.x = x
            self.y = y
            self.z = z
        }

        init(from string: some StringProtocol) {
            let values = string.split(separator: ",").compactMap { Int($0) }

            self.init(x: values[0], y: values[1], z: values[2])
        }
    }

    struct Distance: CustomDebugStringConvertible {
        let p1: Point
        let p2: Point
        let distance: Double

        var debugDescription: String {
            "{ p1: \(p1), p2: \(p2), distance: \(distance) }"
        }
    }

    class Linkage: CustomDebugStringConvertible {
        var connectedPoints: Set<Point>

        init(connectedPoints: Set<Point>) {
            self.connectedPoints = connectedPoints
        }

        init(from distance: Distance) {
            self.connectedPoints = [distance.p1, distance.p2]
        }

        func contains(_ point: Point) -> Bool {
            connectedPoints.contains(point)
        }

        func connect(_ point: Point) {
            connectedPoints.insert(point)
        }

        func merge(with other: Linkage) {
            connectedPoints.formUnion(other.connectedPoints)
        }

        var size: Int {
            connectedPoints.count
        }

        var debugDescription: String {
            self.connectedPoints.debugDescription
        }
    }

    func run(from filePath: URL) throws -> Int {
        let inputText = try String(contentsOf: filePath, encoding: .utf8)
        let points = inputText
            .split(separator: "\n")
            .map(Point.init(from:))

        let lastDistance = createConnections(from: Set(points))

        return lastDistance.p1.x * lastDistance.p2.x
    }

    func createConnections(
        from points: Set<Point>
    ) -> Distance {
        let distances = calculateDistances(of: points)
        var linkages: [Linkage] = []

        func findLinkageIndex(containing point: Day8.Point) -> Int? {
            linkages.firstIndex(where: { $0.contains(point) })
        }

        for distance in distances {
            if let linkageIndex = findLinkageIndex(containing: distance.p1) {
                let linkage = linkages[linkageIndex]
                if let otherLinkageIndex = findLinkageIndex(containing: distance.p2) {
                    if linkageIndex != otherLinkageIndex {
                        let otherLinkage = linkages[otherLinkageIndex]
                        linkage.merge(with: otherLinkage)
                        linkages.remove(at: otherLinkageIndex)
                    }
                } else {
                    linkage.connect(distance.p2)
                }
            } else if let linkageIndex = findLinkageIndex(containing: distance.p2) {
                let linkage = linkages[linkageIndex]
                linkage.connect(distance.p1)
            } else {
                linkages.append(.init(from: distance))
            }

            if linkages.count == 1 && linkages[0].connectedPoints == points {
                return distance
            }
        }

        fatalError("Should never create connections leading to separate linkages")
    }

    func distance(between lhs: Point, and rhs: Point) -> Double {
        sqrt(
            pow(abs(Double(rhs.x - lhs.x)), 2) +
            pow(abs(Double(rhs.y - lhs.y)), 2) +
            pow(abs(Double(rhs.z - lhs.z)), 2)
        )
    }

    func calculateDistances(of points: Set<Point>) -> [Distance] {
        var remainingPoints = points
        var distances: [Distance] = []

        while !remainingPoints.isEmpty {
            let currentPoint = remainingPoints.removeFirst()

            distances += remainingPoints.map { otherPoint in
                Distance(
                    p1: currentPoint,
                    p2: otherPoint,
                    distance: distance(between: currentPoint, and: otherPoint)
                )
            }
        }

        distances.sort()

        return distances
    }
}

extension Day8.Distance: Comparable {
    static func < (lhs: Day8.Distance, rhs: Day8.Distance) -> Bool {
        lhs.distance < rhs.distance
    }
}
