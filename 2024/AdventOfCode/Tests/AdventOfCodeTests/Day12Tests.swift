import Testing
@testable import AdventOfCode

struct Day12Tests {
    @Test(
        arguments: [(Day12.Coordinate, Day12.Coordinate, Bool)](
            arrayLiteral: (.init(x: 1, y: 1), .init(x: 2, y: 1), true),
            (.init(x: 1, y: 1), .init(x: 0, y: 1), true),
            (.init(x: 1, y: 1), .init(x: 1, y: 2), true),
            (.init(x: 1, y: 1), .init(x: 1, y: 0), true)
        )
    ) func coordinateIsNextTo(
        coordinate: Day12.Coordinate,
        other: Day12.Coordinate,
        shouldBeNext: Bool
    ) {
        #expect(Day12.Coordinate(x: 1, y: 1).isNextTo(Day12.Coordinate(x: 2, y: 1)) == true)
    }

    @Test func getSidesCount() {
        let region: [Day12.Coordinate] = [
            [8, 9].map { .init(x: $0, y: 0) },
            [9].map { .init(x: $0, y: 1) },
            [7, 8, 9].map { .init(x: $0, y: 2) },
            [7, 8, 9].map { .init(x: $0, y: 3) },
            [8].map { .init(x: $0, y: 4) },
        ]
            .flatMap { $0 }

        let northSides = Day12.Direction.north
            .filterExternalCells(in: region)
            .sorted { lhs, rhs in
                lhs.y < rhs.y && lhs.x < rhs.x
            }

        #expect(northSides == [
            .init(x: 8, y: 0), .init(x: 9, y: 0),
            .init(x: 7, y: 2), .init(x: 8, y: 2)
        ])

        let count = Day12.Direction.north
            .countSides(in: region)

        #expect(count == 2)

        let southSidesCount = Day12.Direction.south
            .countSides(in: region)

        #expect(southSidesCount == 4)

        let eastSides = Day12.Direction.east
            .filterExternalCells(in: region)
            .sorted { lhs, rhs in
                lhs.x < rhs.x && lhs.y < rhs.y
            }

        #expect(eastSides == [
            .init(x: 9, y: 0), .init(x: 9, y: 1), .init(x: 9, y: 2), .init(x: 9, y: 3),
            .init(x: 8, y: 4)
        ])

        let eastSidesCount = Day12.Direction.east
            .countSides(in: region)

        #expect(eastSidesCount == 2)
    }

    @Test(arguments: Day12.Direction.allCases)
    func getSidesCountForABRegion(direction: Day12.Direction) {
        let region: [Day12.Coordinate] = ABRegion

        #expect(direction.countSides(in: region) == 3)
    }

    @Test func filterExternalCellsForABRedion() {
        let region: [Day12.Coordinate] = ABRegion

        #expect(Day12.Direction.east.filterExternalCells(in: region) == [
            .init(x: 5, y: 0),
            .init(x: 2, y: 1), .init(x: 5, y: 1),
            .init(x: 2, y: 2), .init(x: 5, y: 2),
            .init(x: 0, y: 3), .init(x: 5, y: 3),
            .init(x: 0, y: 4), .init(x: 5, y: 4),
            .init(x: 5, y: 5)
        ])
    }

    @Test func filterAndSortExternalCellsForABRedion() {
        let region: [Day12.Coordinate] = ABRegion

        let presort = Day12.Direction.east
            .filterExternalCells(in: region)
        let cells = presort
            .sorted { lhs, rhs in
                lhs.x < rhs.x || lhs.y < rhs.y
            }

        #expect(cells == [
            .init(x: 0, y: 3), .init(x: 0, y: 4),
            .init(x: 2, y: 1), .init(x: 2, y: 2)
        ] + (0...5).map { .init(x: 5, y: $0) })
    }

    @Test func filterAndSortExternalEastCellsForInputRegion() {
        let region: [Day12.Coordinate] = inputRegionA14

        let cells = Day12.Direction.east
            .filterAndSortExternalCells(in: region)

        #expect(cells == [
            (101, 90), (103, 90),
            (104, 91),
            (104, 92),
            (94, 93), (102, 93),
            (95, 94), (105, 94),
            (103, 95), (105, 95), (107, 95),
            (109, 96),
            (105, 97), (108, 97),
            (110, 98),
            (109, 99),
            (106, 100),
            (98, 101), (100, 101), (103, 101), (107, 101),
            (108, 102)
        ]
            .map(Day12.Coordinate.init)
        )
    }

    @Test(arguments: [(Day12.Direction, Int)](
        arrayLiteral: (.east, 20), (.north, 20), (.south, 17), (.west, 17)
    )) func sidesCountForInputRegion(dir: Day12.Direction, expected: Int) {
        let region = inputRegionA14

        let sides = dir.countSides(in: region)

        #expect(sides == expected)
    }

    @Test func filterAndSortExternalWestCellsForInputRegion() {
        let region: [Day12.Coordinate] = inputRegionA14

        let cells = Day12.Direction.west
            .filterAndSortExternalCells(in: region)

        #expect(cells == [
            (101, 90), (103, 90),
            (101, 91),
            (100, 92),
            (94, 93), (97, 93),
            (93, 94), (97, 94),
            (93, 95), (105, 95), (107, 95),
            (93, 96),
            (92, 97), (107, 97),
            (94, 98),
            (95, 99),
            (95, 100),
            (98, 101), (100, 101), (103, 101), (106, 101),
            (107, 102)
        ]
            .map(Day12.Coordinate.init)
        )
    }
    private let ABRegion: [Day12.Coordinate] = [
        (0...5).map { .init(x: $0, y: 0) },
        [0, 1, 2, 5].map { .init(x: $0, y: 1) },
        [0, 1, 2, 5].map { .init(x: $0, y: 2) },
        [0, 3, 4, 5].map { .init(x: $0, y: 3) },
        [0, 3, 4, 5].map { .init(x: $0, y: 4) },
        (0...5).map { .init(x: $0, y: 5) }
    ]
        .flatMap { $0 }

/*
92 95   100  105  110
 |  |    |    |    |
 .........A.A.......    90
 .........AAAA......
 ........AAAAA......
 ..A..AAAAAA........
 .AAA.AAAAAAAAA.....
 .AAAAAAAAAAA.A.A...    95
 .AAAAAAAAAAAAAAAAA.
 AAAAAAAAAAAAAA.AA..
 ..AAAAAAAAAAAAAAAAA
 ...AAAAAAAAAAAAAAA.
 ...AAAAAAAAAAAA....    100
 ......A.A..A..AA...
 ...............AA..    102
 */
    private let inputRegionA14: [Day12.Coordinate] = [
        (101, 90),
        (101, 91), (102, 91), (103, 91), (104, 91),
        (100, 92), (101, 92), (102, 92), (103, 92), (104, 92),
        (97, 93), (98, 93), (99, 93), (100, 93), (101, 93), (102, 93),
        (97, 94), (98, 94), (99, 94), (100, 94), (101, 94), (102, 94), (103, 94), (104, 94), (105, 94),
        (93, 95), (94, 95), (95, 95), (96, 95), (97, 95), (98, 95), (99, 95), (100, 95), (101, 95), (102, 95), (103, 95), (105, 95),
        (93, 96), (94, 96), (95, 96), (96, 96), (97, 96), (98, 96), (99, 96), (100, 96), (101, 96), (102, 96), (103, 96), (104, 96), (105, 96), (106, 96), (107, 96), (108, 96), (109, 96),
        (92, 97), (93, 97), (94, 97), (95, 97), (96, 97), (97, 97), (98, 97), (99, 97), (100, 97), (101, 97), (102, 97), (103, 97), (104, 97), (105, 97), (107, 97), (108, 97),
        (94, 98), (95, 98), (96, 98), (97, 98), (98, 98), (99, 98), (100, 98), (101, 98), (102, 98), (103, 98), (104, 98), (105, 98), (106, 98), (107, 98), (108, 98), (109, 98), (110, 98),
        (95, 99), (96, 99), (97, 99), (98, 99), (99, 99), (100, 99), (101, 99), (102, 99), (103, 99), (104, 99), (105, 99), (106, 99), (107, 99), (108, 99), (109, 99),
        (95, 100), (96, 100), (97, 100), (98, 100), (99, 100), (100, 100), (101, 100), (102, 100), (103, 100), (104, 100), (105, 100), (106, 100),
        (98, 101), (100, 101), (103, 101), (106, 101), (107, 101),
        (107, 102), (108, 102),
        (103, 90),
        (94, 93),
        (93, 94),
        (94, 94),
        (95, 94),
        (107, 95)
    ]
        .map(Day12.Coordinate.init)
}
