import Parsing
import Foundation

struct Day7 {
    let identifier = "Day7"

    struct State: Equatable {
        var beams: [Int]
        var splitsCount: Int

        mutating func split(at beamIndex: Int) {
            guard beams.contains(beamIndex) else { return }

            beams.removeAll(where: { $0 == beamIndex})

            insertBeam(at: beamIndex - 1)
            insertBeam(at: beamIndex + 1)

            splitsCount += 1
        }

        mutating func insertBeam(at index: Int) {
            if !beams.contains(index) {
                beams.append(index)
            }
        }

        func hasBeam(at index: Int) -> Bool {
            beams.contains(index)
        }
    }

    func run(from filePath: URL) throws -> Int {
        let inputText = try String(contentsOf: filePath, encoding: .utf8)

        return runSimulation(for: inputText)
    }

    func runSimulation(for input: String) -> Int {
        let lines = input.split(separator: "\n")
        let initialState = State(beams: [], splitsCount: 0)
        let result = process(rows: lines, state: initialState)

        return result.splitsCount
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
                }
            }
    }
}
