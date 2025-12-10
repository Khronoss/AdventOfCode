@testable import AdventOfCode
import Testing

struct Day6Tests {
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
                [1, 24, 356],
                [369, 248, 8],
                [32, 581, 175],
                [623, 431, 4]
            ],
            operations: [.multiply, .add, .multiply, .add]
        ))
    }

    @Test func executeSingleOperation() {
        let sut = Day6.Worksheet(
            values: [
                [1, 24, 356],
                [369, 248, 8],
                [32, 581, 175],
                [623, 431, 4]
            ],
            operations: [.multiply, .add, .multiply, .add]
        )
        let expected = 8544

        #expect(sut.runOperation(at: 0) == expected)
    }

    @Test func executeOperations() {
        let sut = Day6.Worksheet(
            values: [
                [1, 24, 356],
                [369, 248, 8],
                [32, 581, 175],
                [623, 431, 4]
            ],
            operations: [.multiply, .add, .multiply, .add]
        )
        let expected = 3263827

        #expect(sut.runOperations() == expected)
    }
}
