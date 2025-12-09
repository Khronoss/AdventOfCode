@testable import AdventOfCode
import Testing

struct Day3Tests {
    @Test(arguments: [
        ([9,8,7,6,5,4,3,2,1,1,1,1,1,1,1], 98),
        ([8,1,1,1,1,1,1,1,1,1,1,1,1,1,9], 89),
        ([2,3,4,2,3,4,2,3,4,2,3,4,2,7,8], 78),
        ([8,1,8,1,8,1,9,1,1,1,1,2,1,1,1], 92)
    ]) func maxJoltageFromBank(_ arg: ([Int], Int)) {
        let sut = Day3()
        let input = arg.0
        let expected = arg.1

        #expect(sut.maxJoltage(from: input) == expected)
    }

    @Test(arguments: [
        ([9,8,7,6,5,4,3,2,1,1,1,1,1,1,1], 0),
        ([9,8,7,6,5,9,3,2,1,1,1,1,1,1,1], 0),
        ([1,1,1,1,1,2,2,2,2,2,1,1], 5),
        ([1,2,3,5,1,2,7,2,4,6,2,7], 6),
        ([], nil),
        ([1], 0),
        ([2,2,2,2], 0)
    ]) func firstIndexOfMaxValue(_ arg: ([Int], Int?)) {
        let sut = arg.0
        let expected = arg.1

        #expect(sut.firstIndexOfMaxValue() == expected)
    }

    @Test(arguments: [
        ("", [Int]()),
        ("987654321111111", [9,8,7,6,5,4,3,2,1,1,1,1,1,1,1])
    ]) func stringToListOfInt(_ arg: (String, [Int])) {
        let sut = arg.0
        let expected = arg.1

        #expect(sut.toListOfInt() == expected)
    }
}
