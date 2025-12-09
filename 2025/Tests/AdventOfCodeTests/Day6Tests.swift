@testable import AdventOfCode
import Testing

struct Day6Tests {
    @Test(arguments: [
        ("123 328  51 64", [123, 328, 51, 64]),
        (" 45 64  387 23", [45, 64, 387, 23]),
        ("  6 98  215 314", [6, 98, 215, 314]),
    ]) func parseRow(_ args: (String, [Int])) throws {
        let input = args.0
        let expected = args.1

        let result = try ParsableWorksheet().valuesRow.parse(input)

        #expect(result == expected)
    }

    @Test func parseOperations() throws {
        let input = "*   +   *   +  "
        let expected = [Day6.Operator.multiply, .add, .multiply, .add]

        let result = try ParsableWorksheet().operatorsRow.parse(input)

        #expect(result == expected)
    }

    @Test func parseInput() throws {
        let sut = Day6()
        let result = try sut.parseInput("""
        123 328  51 64
         45 64  387 23
          6 98  215 314
        *   +   *   +  
        """)

        #expect(result == Day6.Worksheet(
            values: [
                [123, 328, 51, 64],
                [45, 64, 387, 23],
                [6, 98, 215, 314]
            ],
            operations: [.multiply, .add, .multiply, .add]
        ))
    }

    @Test func executeSingleOperation() {
        let sut = Day6.Worksheet(
            values: [
                [123, 328, 51, 64],
                [45, 64, 387, 23],
                [6, 98, 215, 314]
            ],
            operations: [.multiply, .add, .multiply, .add]
        )
        let expected = 33210

        #expect(sut.runOperation(at: 0) == expected)
    }

    @Test func executeOperations() {
        let sut = Day6.Worksheet(
            values: [
                [123, 328, 51, 64],
                [45, 64, 387, 23],
                [6, 98, 215, 314]
            ],
            operations: [.multiply, .add, .multiply, .add]
        )
        let expected = [33210, 490, 4243455, 401]

        #expect(sut.runOperations() == expected)
    }
}
