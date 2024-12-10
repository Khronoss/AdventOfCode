@testable import AdventOfCode
import Testing

struct Day6Tests {

    @Test(
        arguments: Day6.Heading.allCases
    ) func firstObstacleInFrontOfGuardWithEmptyMap(_ heading: Day6.Heading) async throws {
        let sut = Day6()
        let guardState = Day6.GuardState(
            position: .init(x: 3, y: 5),
            heading: heading
        )
        let map = Day6.Map(
            size: (6, 6),
            obstacles: []
        )

        #expect(sut.firstObstacle(
            inFrontOf: guardState,
            in: map
        ) == nil)
    }

    @Test(
        arguments: [
            (Day6.Heading.north, Day6.Position(x: 3, y: 0)),
            (.east, .init(x: 6, y: 5)),
            (.south, .init(x: 3, y: 6)),
            (.west, .init(x: 0, y: 5))
        ]
    ) func firstObstacleInFrontOfGuardWithMapWithSingleObstacle(
        heading: Day6.Heading,
        obstaclePosition: Day6.Position
    ) async throws {
        let sut = Day6()
        let guardState = Day6.GuardState(
            position: .init(x: 3, y: 5),
            heading: heading
        )
        let map = Day6.Map(
            size: (6, 6),
            obstacles: [obstaclePosition]
        )

        #expect(sut.firstObstacle(
            inFrontOf: guardState,
            in: map
        ) == obstaclePosition)
    }

    @Test(
        arguments: [
            (Day6.Heading.north, [
                Day6.Position(x: 3, y: 0),
                Day6.Position(x: 3, y: 2),
                Day6.Position(x: 3, y: 6)
            ],
             Day6.Position(x: 3, y: 2)),
            (.east, [
                Day6.Position(x: 6, y: 5),
                Day6.Position(x: 4, y: 5),
                Day6.Position(x: 0, y: 5)
            ],
             Day6.Position(x: 4, y: 5)),
            (.south, [
                Day6.Position(x: 3, y: 0),
                Day6.Position(x: 3, y: 2),
                Day6.Position(x: 3, y: 6)
            ],
             Day6.Position(x: 3, y: 6)),
            (.west, [
                Day6.Position(x: 6, y: 5),
                Day6.Position(x: 4, y: 5),
                Day6.Position(x: 0, y: 5)
            ],
             Day6.Position(x: 0, y: 5))
        ]
    ) func firstObstacleInFrontOfGuardWithMapWithManyObstacles(
        heading: Day6.Heading,
        obstaclePositions: [Day6.Position],
        expectingObstacle: Day6.Position
    ) async throws {
        let sut = Day6()
        let guardState = Day6.GuardState(
            position: .init(x: 3, y: 5),
            heading: heading
        )
        let map = Day6.Map(
            size: (6, 6),
            obstacles: obstaclePositions
        )

        #expect(sut.firstObstacle(
            inFrontOf: guardState,
            in: map
        ) == expectingObstacle)
    }

    @Test func moveGuard() async throws {
        let sut = Day6()

        let steps = sut.moveGuard(
            Day6.GuardState(position: Day6.Position(x: 3, y: 5), heading: .north),
            in: Day6.Map(size: (6, 6), obstacles: [Day6.Position(x: 3, y: 0)])
        )

        #expect(
            steps.map(\.position) == [
                .init(x: 3, y: 4),
                .init(x: 3, y: 3),
                .init(x: 3, y: 2),
                .init(x: 3, y: 1),
                .init(x: 4, y: 1),
                .init(x: 5, y: 1)
            ]
        )
    }

    @Test func moveGuardInEmptyMap() async throws {
        let sut = Day6()

        let steps = sut.moveGuard(
            Day6.GuardState(position: Day6.Position(x: 3, y: 5), heading: .north),
            in: Day6.Map(size: (6, 6), obstacles: [])
        )

        #expect(
            steps.map(\.position) == [
                .init(x: 3, y: 4),
                .init(x: 3, y: 3),
                .init(x: 3, y: 2),
                .init(x: 3, y: 1),
                .init(x: 3, y: 0)
            ]
        )
    }
}
