@testable import AdventOfCode
import Testing

struct Day7Tests {
    @Test func createBeam() {
        let row = "..S..."
        var state = Day7.State(beams: [:])
        let sut = Day7()

        sut.process(row: row, state: &state)

        #expect(state == .init(beams: [2: 1]))
    }

    @Test func processSplitBeam() {
        let row = ".^...^."
        var state = Day7.State(beams: [5: 1])
        let sut = Day7()

        sut.process(row: row, state: &state)

        #expect(state == .init(beams: [4: 1, 6: 1], splitsCount: 1))
    }

    @Test func processMultipleRows() {
        let rows = [
            "..S...",
            "......",
            "..^.^.",
            "......",
            ".^.^.."
        ]
        let state = Day7.State(beams: [:])
        let sut = Day7()

        let result = sut.process(rows: rows, state: state)

        #expect(result == .init(beams: [0: 1, 2: 2, 4: 1], splitsCount: 3))
    }

    @Test func stateSplit() {
        var sut = Day7.State(beams: [2: 1])

        sut.split(at: 2)

        #expect(sut.nextState == .init(beams: [1: 1, 3: 1], splitsCount: 1))
    }

    @Test func stateSplitWithExistingBeam() {
        var sut = Day7.State(beams: [2: 1, 4: 1])

        sut.split(at: 2)
        sut.split(at: 4)

        #expect(sut.nextState == .init(beams: [1: 1, 3: 2, 5: 1], splitsCount: 2))
    }
}
