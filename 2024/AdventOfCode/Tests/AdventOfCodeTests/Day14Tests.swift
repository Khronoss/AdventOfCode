import Testing
@testable import AdventOfCode

struct Day14Tests {
    @Test func robotAfter5Steps() {
        let robot = Day14.Robot(
            position: .init(x: 2, y: 4),
            velocity: .init(x: 2, y: -3)
        )
        let grid = Day14.Position(x: 11, y: 7)

        #expect(robot.positionAfter(steps: 5, grid: grid) == .init(x: 1, y: 3))
    }

    @Test func robotAfter1Step() {
        let robot = Day14.Robot(
            position: .init(x: 2, y: 4),
            velocity: .init(x: 2, y: -3)
        )
        let grid = Day14.Position(x: 11, y: 7)

        #expect(robot.positionAfter(steps: 1, grid: grid) == .init(x: 4, y: 1))
    }

    @Test func robotAfter1StepThatWraps() {
        let robot = Day14.Robot(
            position: .init(x: 2, y: 0),
            velocity: .init(x: 2, y: -3)
        )
        let grid = Day14.Position(x: 11, y: 7)

        #expect(robot.positionAfter(steps: 1, grid: grid) == .init(x: 4, y: 4))
    }
}
