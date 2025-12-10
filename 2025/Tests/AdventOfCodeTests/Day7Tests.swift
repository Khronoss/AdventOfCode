@testable import AdventOfCode
import Testing

struct Day7Tests {
    @Test func createBeam() {
        let row = "..S..."
        var state = Day7.State(beams: [], splitsCount: 0)
        let sut = Day7()

        sut.process(row: row, state: &state)

        #expect(state == .init(beams: [2], splitsCount: 0))
    }

    @Test func processSplitBeam() {
        let row = ".^...^."
        var state = Day7.State(beams: [5], splitsCount: 0)
        let sut = Day7()

        sut.process(row: row, state: &state)

        #expect(state == .init(beams: [4, 6], splitsCount: 1))
    }

    @Test func processMultipleRows() {
        let rows = [
            "..S...",
            "......",
            "..^.^.",
            "......",
            ".^.^.."
        ]
        let state = Day7.State(beams: [], splitsCount: 0)
        let sut = Day7()

        let result = sut.process(rows: rows, state: state)

        #expect(result == .init(beams: [0, 2, 4], splitsCount: 3))
    }

    @Test func stateSplit() {
        var sut = Day7.State(beams: [2], splitsCount: 0)

        sut.split(at: 2)

        #expect(sut == .init(beams: [1, 3], splitsCount: 1))
    }

    @Test func stateSplitWithExistingBeam() {
        var sut = Day7.State(beams: [2, 4], splitsCount: 0)

        sut.split(at: 2)
        sut.split(at: 4)

        #expect(sut == .init(beams: [1, 3, 5], splitsCount: 2))
    }
}
