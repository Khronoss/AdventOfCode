@testable import AdventOfCode
import Testing

struct Day5Tests {
    @Test func databaseParsing() throws {
        let input = """
            3-5
            10-14
            16-20
            12-18

            1
            5
            8
            11
            17
            32
            """

        let sut = Day5()
        let expected = Day5.Database.testDatabase

        try #expect(sut.parsedDatabase(from: input) == expected)
    }

    @Test func databaseAvailableFreshIDs() {
        let sut = Day5.Database.testDatabase
        let expected = [5, 11, 17]

        #expect(sut.getAvailableFreshIDs() == expected)
    }

    @Test func databaseAllPossibleFreshIDs() {
        let sut = Day5.Database.testDatabase
        let expected = [
            3...5,
            10...20
        ]
        let result = sut.getMergedFreshIDRanges()
            .sorted(by: { $0.lowerBound < $1.lowerBound })

        #expect(result == expected)
    }
}

extension Day5.Database {
    static var testDatabase: Self {
        Day5.Database(
            freshIDRanges: [
                3...5,
                10...14,
                16...20,
                12...18
            ],
            availableIDs: [1, 5, 8, 11, 17, 32]
        )
    }
}
