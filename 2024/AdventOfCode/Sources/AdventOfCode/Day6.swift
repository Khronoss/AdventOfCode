import Foundation

struct Day6: Challenge {
    struct Failure: Error {
        let message: String
    }

    var useExampleInput: Bool {
        true
    }

    func execute(
        withInput input: String,
        log: (String, Any?) -> Void
    ) throws {
        log("Day6", nil)

        let (map, guardState) = try initialize(withInput: input)

        log("Guard initial state", guardState)

        let visitedCells = [guardState] + moveGuard(guardState, in: map)
        let uniqueVisitedCells = Set(visitedCells.map(\.position))

        let possibleObstacles = (0..<visitedCells.count)
            .compactMap { cellIdx in
                let cell = visitedCells[cellIdx]
                let visitedCells = visitedCells[...cellIdx]
                if isLoopingWithObstacle(inFrontOf: cell, in: map, visitedCells: Array(visitedCells)) {
                    return cell.move().position
                } else {
                    return nil
                }
            }

        printMap(map, visitedCells, potentialObstacles: possibleObstacles)

        log("Visited cells count", uniqueVisitedCells.count)
//        log("Possible obstacles", possibleObstacles)
        log("Possible obstacles count", possibleObstacles.count)
    }

    func initialize(withInput input: String) throws -> (Map, GuardState) {
        var guardState: GuardState?
        var obstacles: [Position] = []

        let rows = input.split(separator: "\n")
        let height = rows.count
        let width = rows.first!.count

        for y in (0..<height) {
            for x in (0..<width) {
                let position = Position(x: x, y: y)
                let cell = Self.getCell(at: position, in: rows)

                if cell.isObstacle {
                    obstacles.append(position)
                } else if cell.isGuard {
                    guardState = GuardState(position: position, heading: .north)
                }
            }
        }

        guard let guardState else {
            throw Failure(message: "Could not load guard state!")
        }

        return (
            Map(size: (width, height), obstacles: obstacles),
            guardState
        )
    }

    static func getCell(at position: Position, in rows: [some StringProtocol]) -> Character {
        let line = rows[position.y]

        return line[line.index(line.startIndex, offsetBy: position.x)]
    }

    func printMap(_ map: Map, _ visitedCells: some Sequence<GuardState>, potentialObstacles: [Position]) {
        (0..<map.size.height).forEach { y in
            print((0..<map.size.width).map { x in
                let position = Position(x: x, y: y)

                if potentialObstacles.contains(position) {
                    return "O"
                } else if map.isObstacle(position) {
                    return "#"
                } else {
                    let visitedCellsForPosition = visitedCells.filter { $0.position == position }
                    if visitedCellsForPosition.isEmpty {
                        return "."
                    } else {
                        if visitedCellsForPosition.allSatisfy({ $0.heading.isVertical }) {
                            return "|"
                        } else if visitedCellsForPosition.allSatisfy({ $0.heading.isHorizontal }) {
                            return "-"
                        } else {
                            return "+"
                        }
                    }
                }
            }.joined())
        }
    }

    func moveGuard(_ guardState: GuardState, in map: Map) -> [GuardState] {
        guard let obstacle = firstObstacle(inFrontOf: guardState, in: map) else {
            var steps: [GuardState] = []

            var step = guardState.move()
            while (!map.isOutOfBounds(step.position)) {
                steps.append(step)
                step = step.move()
            }
            return steps
        }

        let steps = getSteps(from: guardState, until: obstacle)

        return steps + moveGuard(GuardState(position: steps.last!.position, heading: guardState.heading.next), in: map)
    }

    func getSteps(from guardState: GuardState, until position: Position) -> [GuardState] {
        var steps: [GuardState] = []

        var step = guardState
        while (step.move().position != position) {
            step = step.move()
            steps.append(step)
        }
        return steps
    }

    func firstObstacle(inFrontOf guardState: GuardState, in map: Map) -> Position? {
        switch guardState.heading {
        case .north:
            return map.obstacles
                .filter { $0.x == guardState.position.x }
                .sorted { $0.y > $1.y }
                .first(where: { $0.y < guardState.position.y })
        case .east:
            return map.obstacles
                .filter { $0.y == guardState.position.y }
                .sorted { $0.x < $1.x }
                .first(where: { $0.x > guardState.position.x })
        case .south:
            return map.obstacles
                .filter { $0.x == guardState.position.x }
                .sorted { $0.y < $1.y }
                .first(where: { $0.y > guardState.position.y })
        case .west:
            return map.obstacles
                .filter { $0.y == guardState.position.y }
                .sorted { $0.x > $1.x }
                .first(where: { $0.x < guardState.position.x })
        }
    }

    func isLoopingWithObstacle(
        inFrontOf guardState: GuardState,
        in map: Map,
        visitedCells: [GuardState]
    ) -> Bool {
        let rotatedGuard = GuardState(position: guardState.position, heading: guardState.heading.next)
        guard let obstacle = firstObstacle(inFrontOf: rotatedGuard, in: map) else {
            return false
        }

        let previousStep: Position = switch rotatedGuard.heading {
        case .north:
                .init(x: obstacle.x, y: obstacle.y + 1)
        case .east:
                .init(x: obstacle.x - 1, y: obstacle.y)
        case .south:
                .init(x: obstacle.x, y: obstacle.y - 1)
        case .west:
                .init(x: obstacle.x + 1, y: obstacle.y)
        }

        let bigStep = GuardState(position: previousStep, heading: rotatedGuard.heading)

        if visitedCells.contains(bigStep) {
            return true
        } else {
            let newSteps = getSteps(from: rotatedGuard, until: obstacle)

            return isLoopingWithObstacle(inFrontOf: bigStep, in: map, visitedCells: visitedCells + newSteps)
        }
    }

    // MARK: - Models
    typealias Size = (width: Int, height: Int)

    struct Position: Hashable {
        let x: Int
        let y: Int
    }

    struct GuardState: Hashable {
        let position: Position
        let heading: Heading

        func move() -> GuardState {
            GuardState(
                position: heading.move(position),
                heading: heading
            )
        }
    }

    enum Heading: Hashable {
        case north, east, south, west

        static var allCases: [Self] { [.north, .east, .south, .west] }

        var next: Self {
            switch self {
            case .north: .east
            case .east: .south
            case .south: .west
            case .west: .north
            }
        }

        func move(_ position: Day6.Position) -> Day6.Position {
            switch self {
            case .north:
                    .init(x: position.x, y: position.y - 1)
            case .east:
                    .init(x: position.x + 1, y: position.y)
            case .south:
                    .init(x: position.x, y: position.y + 1)
            case .west:
                    .init(x: position.x - 1, y: position.y)
            }
        }

        var isVertical: Bool {
            self == .north || self == .south
        }

        var isHorizontal: Bool {
            self == .east || self == .west
        }
    }

    struct State {
        let map: Map
        var guardState: GuardState
        var visitedCells: [GuardState]

        init(map: Map, guardState: GuardState, visitedCells: [GuardState] = []) {
            self.map = map
            self.guardState = guardState
            self.visitedCells = visitedCells
        }


        func addingObstacle(_ position: Position) -> Self {
            .init(
                map: map.addingObstacle(at: position),
                guardState: guardState,
                visitedCells: visitedCells
            )
        }

        func guardIsOUtOfBounds() -> Bool {
            map.isOutOfBounds(guardState.position)
        }

        mutating
        func update() {
            visitedCells.append(guardState)

            let newGuardPosition = guardState.heading.move(guardState.position)

            if map.isObstacle(newGuardPosition) {
                // rotate
                let newHeading = guardState.heading.next
                let newGuardPosition = newHeading.move(guardState.position)

                guardState = .init(
                    position: newGuardPosition,
                    heading: newHeading
                )
            } else {
                guardState = .init(
                    position: newGuardPosition,
                    heading: guardState.heading
                )
            }
        }
    }

    struct Map {
        let size: Size
        let obstacles: [Position]

        func addingObstacle(at position: Position) -> Self {
            .init(size: size, obstacles: obstacles + [position])
        }

        func isOutOfBounds(_ position: Position) -> Bool {
            position.x < 0 ||
            position.y < 0 ||
            position.x >= size.width ||
            position.y >= size.height
        }

        func isObstacle(_ position: Position) -> Bool {
            obstacles.contains(position)
        }
    }
}

extension Character {
    var isObstacle: Bool {
        self == "#"
    }

    var isGuard: Bool {
        self == "^"
    }
}
