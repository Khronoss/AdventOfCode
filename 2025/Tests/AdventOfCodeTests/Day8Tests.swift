@testable import AdventOfCode
import Foundation
import Testing

struct Day8Tests {
    @Test(arguments: [
        (Day8.Point(x: 2, y: 3, z: 1), Day8.Point(x: 4, y: 6, z: 2)),
        (Day8.Point(x: 4, y: 6, z: 2), Day8.Point(x: 2, y: 3, z: 1)),
        (Day8.Point(x: -2, y: 6, z: 2), Day8.Point(x: -4, y: 3, z: 1)),
        (Day8.Point(x: -4, y: 3, z: 1), Day8.Point(x: -2, y: 6, z: 2)),
    ]) func distanceCalculation(_ args: (Day8.Point, Day8.Point)) {
        let p1 = args.0
        let p2 = args.1
        let sut = Day8()

        let result = sut.distance(between: p1, and: p2)

        #expect(result == sqrt(14))
    }

//    @Test func calculateDistances() {
//        let points = [
//            Day8.Point(x: 2, y: 3, z: 1),
//            Day8.Point(x: 4, y: 6, z: 2),
//            Day8.Point(x: 1, y: 1, z: 1),
//            Day8.Point(x: -2, y: -3, z: -4)
//        ]
//        let sut = Day8()
//
//        let result = sut.calculateDistances(of: Set(points))
//
//        #expect(result == [
//            .init(p1: points[0], p2: points[2], distance: sqrt(5)),
//            .init(p1: points[0], p2: points[1], distance: sqrt(14)),
//            .init(p1: points[1], p2: points[2], distance: sqrt(35)),
//            .init(p1: points[2], p2: points[3], distance: sqrt(50)),
//            .init(p1: points[0], p2: points[3], distance: sqrt(77)),
//            .init(p1: points[1], p2: points[3], distance: sqrt(153))
//        ])
//    }

//    @Test func calculateDistancesFromTestSample() throws {
//        let points = Self.testSample
//        let sut = Day8()
//        
//        let result = sut.calculateDistances(of: Set(points))
//
//        try #require(!result.isEmpty)
//
//        #expect(result[0].p1 == points[0])
//        #expect(result[0].p2 == points[points.count - 1])
//        #expect(result[1].p1 == points[0])
//        #expect(result[1].p2 == points[7])
//    }

    @Test func graphContainsPoint() {
        let p1 = Day8.Point(x: 2, y: 3, z: 1)
        let p2 = Day8.Point(x: -2, y: -3, z: -4)
        let graph = Day8.Linkage(from: .init(p1: p1, p2: p2, distance: 5))

        #expect(graph.contains(p1) == true)
        #expect(graph.contains(p2) == true)
        #expect(graph.contains(.init(x: 10, y: 10, z: 10)) == false)
    }

    @Test func graphNewConnection() {
        let p1 = Day8.Point(x: 2, y: 3, z: 1)
        let p2 = Day8.Point(x: -2, y: -3, z: -4)
        let p3 = Day8.Point(x: 1, y: 2, z: 3)
        let graph = Day8.Linkage(from: .init(p1: p1, p2: p2, distance: 5))

        graph.connect(p3)

        #expect(graph.contains(p3) == true)
    }

    @Test func createConnectionsFromPoints() {
        let points = Self.testSample
        let sut = Day8()

        let result = sut.createConnections(from: Set(points))

        #expect(result.p1 == points[12])
        #expect(result.p2 == points[10])
    }

    static let testSample = [
        Day8.Point(x: 162, y: 817, z: 812),
        Day8.Point(x: 57, y: 618, z: 57),
        Day8.Point(x: 906, y: 360, z: 560),
        Day8.Point(x: 592, y: 479, z: 940),
        Day8.Point(x: 352, y: 342, z: 300),
        Day8.Point(x: 466, y: 668, z: 158),
        Day8.Point(x: 542, y: 29, z: 236),
        Day8.Point(x: 431, y: 825, z: 988),
        Day8.Point(x: 739, y: 650, z: 466),
        Day8.Point(x: 52, y: 470, z: 668),
        Day8.Point(x: 216, y: 146, z: 977),
        Day8.Point(x: 819, y: 987, z: 18),
        Day8.Point(x: 117, y: 168, z: 530),
        Day8.Point(x: 805, y: 96, z: 715),
        Day8.Point(x: 346, y: 949, z: 466),
        Day8.Point(x: 970, y: 615, z: 88),
        Day8.Point(x: 941, y: 993, z: 340),
        Day8.Point(x: 862, y: 61, z: 35),
        Day8.Point(x: 984, y: 92, z: 344),
        Day8.Point(x: 425, y: 690, z: 689)
    ]
}
