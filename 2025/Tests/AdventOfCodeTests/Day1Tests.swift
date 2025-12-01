@testable import AdventOfCode
import Testing

struct Day1Tests {

    @Test func numberOfZeroStops() async throws {
        let sut = Day1()
        let steps: [Day1.Step] = [
            .left(68),
            .left(30),
            .right(48),
            .left(5),
            .right(60),
            .left(55),
            .left(1),
            .left(99),
            .right(14),
            .left(82)
        ]

        let result = sut.numberOf(0, forSteps: steps)

        #expect(result == 6)
    }

    @Test(arguments: [(step: Day1.Step, expected: Int)](
        arrayLiteral: (.left(10), 40),
        (.right(10), 60),
        (.left(50), 0),
        (.right(50), 0),
        (.left(100), 50),
        (.right(100), 50),
        (.left(60), 90),
        (.right(60), 10),
        (.left(200), 50),
        (.right(200), 50),
        (.left(230), 20),
        (.right(230), 80)
    ))
    func nextValue(input: (step: Day1.Step, expected: Int)) {
        let sut = Day1()
        let result = sut.nextValue(forStep: input.step, currentValue: 50)

        #expect(result == input.expected)
    }

    @Test func parsingSteps() throws {
        let input = """
            L68
            L30
            R48
            L5
            R60
            L55
            L1
            L99
            R14
            L82
            """
        let expected: [Day1.Step] = [
            .left(68),
            .left(30),
            .right(48),
            .left(5),
            .right(60),
            .left(55),
            .left(1),
            .left(99),
            .right(14),
            .left(82)
        ]

        let result = try Day1.ParsableStep().parse(input)

        #expect(result == expected)
    }
}
