import Testing
@testable import AdventOfCode

struct Day11Tests {
    @Test func splitArray() throws {
        let evenArrayOfInt = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
        let oddArrayOfInt = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]

        #expect(evenArrayOfInt.split(in: 2) == [
            [1, 2, 3, 4, 5],
            [6, 7, 8, 9, 10]
        ])

        #expect(oddArrayOfInt.split(in: 2) == [
            [1, 2, 3, 4, 5],
            [6, 7, 8, 9, 10, 11]
        ])

        #expect(evenArrayOfInt.split(in: 3) == [
            [1, 2, 3],
            [4, 5, 6],
            [7, 8, 9, 10]
        ])

        #expect(oddArrayOfInt.split(in: 3) == [
            [1, 2, 3],
            [4, 5, 6],
            [7, 8, 9, 10, 11]
        ])
    }

    @Test func arrayChunks() throws {
        let evenArrayOfInt = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
        let oddArrayOfInt = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]

        #expect(evenArrayOfInt.chunks(of: 2) == [
            [1, 2], [3, 4], [5, 6],
            [7, 8], [9, 10]
        ])

        #expect(oddArrayOfInt.chunks(of: 2) == [
            [1, 2], [3, 4], [5, 6],
            [7, 8], [9, 10], [11]
        ])

//        #expect(evenArrayOfInt.split(in: 3) == [
//            [1, 2, 3],
//            [4, 5, 6],
//            [7, 8, 9, 10]
//        ])
//
//        #expect(oddArrayOfInt.split(in: 3) == [
//            [1, 2, 3],
//            [4, 5, 6],
//            [7, 8, 9, 10, 11]
//        ])
    }
}
