import Testing
@testable import AdventOfCode

struct Day13Tests {
    @Test func prizeParsing() throws {
        #expect(
            try Day13.PrizeParser().parse("X=8400, Y=5400") == Day13.Position(x: 8400, y: 5400)
        )
    }

    @Test func buttonParsing() throws {
        #expect(
            try Day13.ButtonParser().parse("X+94, Y+34") == Day13.ClawMachine.Button(move: .init(x: 94, y: 34))
        )
    }

    @Test func clawMachineParsing() throws {
        #expect(
            try Day13.ClawMachineParser().parse("""
            Button A: X+94, Y+34
            Button B: X+22, Y+67
            Prize: X=8400, Y=5400
            """) == Day13.ClawMachine(
                btnA: .init(move: .init(x: 94, y: 34)),
                btnB: .init(move: .init(x: 22, y: 67)),
                prize: .init(x: 8400, y: 5400)
            )
        )
    }

    @Test func manyClawMachinesParsing() throws {
        #expect(
            try Day13.ManyClawMachineParser().parse("""
            Button A: X+94, Y+34
            Button B: X+22, Y+67
            Prize: X=8400, Y=5400
            
            Button A: X+26, Y+66
            Button B: X+67, Y+21
            Prize: X=12748, Y=12176
            """) == [
                Day13.ClawMachine(
                    btnA: .init(move: .init(x: 94, y: 34)),
                    btnB: .init(move: .init(x: 22, y: 67)),
                    prize: .init(x: 8400, y: 5400)
                ),
                Day13.ClawMachine(
                    btnA: .init(move: .init(x: 26, y: 66)),
                    btnB: .init(move: .init(x: 67, y: 21)),
                    prize: .init(x: 12748, y: 12176)
                )
            ]
        )
    }

    @Test func clawMachineOptimalMoves() {
        let sut = Day13.ClawMachine(
            btnA: .init(move: .init(x: 94, y: 34)),
            btnB: .init(move: .init(x: 22, y: 67)),
            prize: .init(x: 8400, y: 5400)
        )

        // Part1
        // #expect(sut.getOptimalMoves() == (A: 80, B: 40))
        #expect(sut.getOptimalMoves() == (A: 80, B: 40))
    }

    @Test func clawMachineOptimalMovesWhenPrizeIsUnreachable() {
        let sut = Day13.ClawMachine(
            btnA: .init(move: .init(x: 26, y: 66)),
            btnB: .init(move: .init(x: 67, y: 21)),
            prize: .init(x: 12748, y: 12176)
        )
        // Part1
        // #expect(sut.getOptimalMoves() == (A: 0, B: 0))
        #expect(sut.getOptimalMoves() == (A: 118679050709, B: 103199174542))
    }

    @Test func totalCostForClawMachinesOptimalMoves() {
        let optimalMoves: [(A: Int, B: Int)] = [
            (80, 40), (0, 0), (38, 86), (0, 0)
        ]
        let sut = Day13()

        #expect(sut.totalCost(moves: optimalMoves) == 480)
    }
}
