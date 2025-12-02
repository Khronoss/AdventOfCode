@testable import AdventOfCode
import Testing

struct Day2Tests {

    @Test func rangesParsing() throws {
        let sut = Day2()
        let input = "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124"
        let expected = [
            11...22,
            95...115,
            998...1012,
            1188511880...1188511890,
            222220...222224,
            1698522...1698528,
            446443...446449,
            38593856...38593862,
            565653...565659,
            824824821...824824827,
            2121212118...2121212124
        ]

        #expect(try sut.rangesOfIDs(from: input) == expected)
    }

    @Test func addAllValidIDs() {
        let sut = Day2()
        let input = [
            11...22,
            95...115,
            998...1012,
            1188511880...1188511890,
            222220...222224,
            1698522...1698528,
            446443...446449,
            38593856...38593862,
        ]
        let expected = 1227775554

        #expect(sut.addAllValidIDs(from: input) == expected)
    }

    @Test(arguments: [
        (11...22, [11, 22]),
        (99...115, [99])
    ]) func findValidIDsForRange(arg: (ClosedRange<Int>, [Int])) {
        let sut = Day2()
        let range = arg.0
        let expected = arg.1

        #expect(sut.findValidIDs(for: range) == expected)
    }

    @Test(arguments: [
        (11...22, 1...2),
        (95...115, 9...11),
        (998...1012, 9...10)
    ]) func testingRange(arg: (ClosedRange<Int>, ClosedRange<Int>)) {
        let sut = Day2()
        let range = arg.0
        let expected = arg.1

        #expect(sut.testingRange(from: range) == expected)
    }

    @Test(arguments: [
        (1...2, [11, 22]),
        (9...11, [99, 1010, 1111]),
        (9...9, [99])
    ]) func allValidIDs(arg: (ClosedRange<Int>, [Int])) {
        let sut = Day2()
        let range = arg.0
        let expected = arg.1

        #expect(sut.allValidIDs(from: range) == expected)
    }

    @Test(arguments: [
        ("abcd", roundedUp: false, "ab"),
        ("abcd", roundedUp: true, "ab"),
        ("abcdefg", roundedUp: false, "abc"),
        ("abcdefg", roundedUp: true, "abcd")
    ]) func stringFirstHalf(arg: (String, roundedUp: Bool, Substring)) {
        let input = arg.0
        let roundedUp = arg.1
        let expected = arg.2

        #expect(input.firstHalf(roundedUp: roundedUp) == expected)
    }

    @Test(arguments: [
        ("abcd", "abcdabcd"),
        ("abcdefg", "abcdefgabcdefg")
    ]) func stringRepeatedTwice(arg: (String, String)) {
        let input = arg.0
        let expected = arg.1

        #expect(input.repeatedTwice() == expected)
    }
}
