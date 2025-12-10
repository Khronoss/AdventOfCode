import Parsing
import Foundation

struct Day7 {
    let identifier = "Day7"

    struct State: Equatable {
        let beams: [Int: Int]
        var nextBeams: [Int: Int] = [:]
        var splitsCount: Int = 0

        mutating func split(at beamIndex: Int) {
            guard let beamsCount = beams[beamIndex] else { return }

            insertBeams(beamsCount, at: beamIndex - 1)
            insertBeams(beamsCount, at: beamIndex + 1)

            splitsCount += 1
        }

        mutating func insertBeam(at index: Int) {
            insertBeams(1, at: index)
        }

        mutating func insertBeams(_ count: Int, at index: Int) {
            nextBeams[index] = (nextBeams[index] ?? 0) + count
        }

        mutating func moveBeam(at index: Int) {
            nextBeams[index] = (beams[index] ?? 0) + (nextBeams[index] ?? 0)
        }

        var nextState: Self {
            if nextBeams.isEmpty { return self }

            return .init(beams: nextBeams, splitsCount: splitsCount)
        }
    }

    func run(from filePath: URL) throws -> Int {
        let inputText = try String(contentsOf: filePath, encoding: .utf8)

        return runSimulation(for: inputText)
    }

    func runSimulation(for input: String) -> Int {
        let lines = input.split(separator: "\n")
        let initialState = State(beams: [:])
        let result = process(rows: lines, state: initialState)

        return result.beams.reduce(0) { $0 + $1.value }
    }

    func process(rows: [some StringProtocol], state: State) -> State {
        rows.reduce(into: state) { partialResult, row in
            process(row: row, state: &partialResult)
        }
    }

    func process(row: some StringProtocol, state: inout State) {
        row.enumerated()
            .forEach { (offset, char) in
                if char == "S" {
                    state.insertBeam(at: offset)
                } else if char == "^" {
                    state.split(at: offset)
                } else if char == "." {
                    state.moveBeam(at: offset)
                }
            }

        state = state.nextState
    }
}
