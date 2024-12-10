import Foundation
import FileReader

@Observable
class Day6Model {
    var map: Map?

    var inputFile: String {
        "Day6_example"
//        "Day6_input"
    }

    func setup() {
        do {
            let file = try FileReader()
                .readFile(inputFile, from: .module)

            self.map = Map(input: file)
        } catch {
            print("Failed load ing file", error)
        }
    }

    func step() {
        guard var map else { return }

        Self.move(
            guardState: &map.guardState,
            visitedCells: &map.visitedCells,
            in: map
        )

        self.map = map
    }

//    func execute(
//        withInput input: String,
//        log: (String, Any?) -> Void
//    ) throws {
//        print("Day6")
//        let map = Map(input: input)
//        var visitedCells: [GuardState] = []
//        var possibleObstacle: [Position] = []
//
//        guard var guardState = getGuardState(from: map) else {
//            return log("Guard couldn't be found!", nil)
//        }
//
//
//        log("Guard", guardState)
//
//        while move(
//            guardState: &guardState,
//            visitedCells: &visitedCells,
//            possibleObstacle: &possibleObstacle,
//            in: map
//        ) {}
//
//        log("End run", nil)
//        log("Visited cells", visitedCells.count)
//        log("Possible obstacles", possibleObstacle.count)
//    }

//    func getGuardState(from map: Map) -> GuardState? {
//        for y in 0..<map.size.height {
//            for x in 0..<map.size.width {
//                let position = Position(x: x, y: y)
//                if map.getCell(at: position).isGuard {
//                    return GuardState(position: position, heading: .north)
//                }
//            }
//        }
//        return nil
//    }

    @discardableResult
    static func move(
        guardState: inout GuardState,
        visitedCells: inout [GuardState],
//        possibleObstacle: inout [Position],
        in map: Map
    ) -> CanContinue {
        let newPosition = guardState.heading.update(guardState.position)

        guard !map.isOutOfBounds(newPosition) else {
            return false
        }

//        if simulateObstacleResultInLoop(
//            guardState: guardState,
//            visitedCells: visitedCells,
//            map: map
//        ) {
//            possibleObstacle.append(newPosition)
//        }

        if map.isObstacle(newPosition) {
            let newHeading = guardState.heading.next
            let newPosition = newHeading.update(guardState.position)

            guardState.heading = newHeading
            guardState.position = newPosition
            visitedCells.append(guardState)
        } else {
            guardState.position = newPosition
            visitedCells.append(guardState)
        }
        return true
    }

//    func simulateObstacleResultInLoop(
//        guardState: GuardState,
//        visitedCells: [GuardState],
//        map: Map
//    ) -> Bool {
//        var guardState = guardState
//        let newHeading = guardState.heading.next
//
//        while true {
//            let newPosition = newHeading.update(guardState.position)
//            let newGuardState = GuardState(position: newPosition, heading: newHeading)
//
//            if visitedCells.contains(newGuardState) {
//                return true
//            } else if isOutOfMap(newPosition, in: map) {
//                return false
//            } else if map.getCell(at: newPosition).isObstacle {
//                return false
//            }
//
//            guardState = newGuardState
//        }
//    }
}

extension Day6Model {
    typealias CanContinue = Bool
    typealias Size = (width: Int, height: Int)

    struct GuardState: Equatable {
        var position: Position
        var heading: Direction
    }

    struct Position: Hashable {
        let x: Int
        let y: Int

        func scaled(by scalar: Int) -> Self {
            .init(x: x * scalar, y: y * scalar)
        }
    }

    enum Direction {
        case north, east, south, west

        var next: Direction {
            switch self {
            case .north: .east
            case .east: .south
            case .south: .west
            case .west: .north
            }
        }

        func update(_ position: Position) -> Position {
            switch self {
            case .north: Position(x: position.x, y: position.y - 1)
            case .east: Position(x: position.x + 1, y: position.y)
            case .south: Position(x: position.x, y: position.y + 1)
            case .west: Position(x: position.x - 1, y: position.y)
            }
        }
    }

    struct Map {

        let obstacles: [Position]
        let size: Size
        var guardState: GuardState!
        var visitedCells: [GuardState] = []

        init(input: String) {
            let cells = input.split(separator: "\n")
            self.size = (cells.first?.count ?? 0, cells.count)

            var obstacles: [Position] = []
            for y in (0..<size.height) {
                for x in (0..<size.width) {
                    let position = Position(x: x, y: y)
                    let cell = Self.getCell(at: position, cells: cells)

                    if cell.isObstacle {
                        obstacles.append(position)
                    } else if cell.isGuard {
                        guardState = .init(position: position, heading: .north)
                        visitedCells.append(guardState)
                    }
                }
            }
            self.obstacles = obstacles
        }

        static func getCell(
            at position: Position,
            cells: [Substring]
        ) -> Character {
            let line = cells[position.y]

            return line[line.index(line.startIndex, offsetBy: position.x)]
        }

        func isObstacle(_ position: Position) -> Bool {
            obstacles.contains(position)
        }

        func isOutOfBounds(_ position: Position) -> Bool {
            position.x < 0 ||
            position.y < 0 ||
            position.x >= size.width ||
            position.y >= size.height
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
