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

    @Test func addAllInvalidIDs() {
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
            565653...565659,
            824824821...824824827,
            2121212118...2121212124
        ]
        let expected = 4174379265

        #expect(sut.addAllInvalidIDs(from: input) == expected)
    }

    @Test(arguments: [
        (11...22, [11, 22]),
        (99...115, [99, 111])
    ]) func findInvalidIDsForRange(arg: (ClosedRange<Int>, [Int])) {
        let sut = Day2()
        let range = arg.0
        let expected = arg.1

        #expect(sut.findInvalidIDs(for: range) == expected)
    }

    @Test(arguments: [
        11,
        123123,
        1234567812345678
    ]) func intIsRepeatingTwice(_ input: Int) {
        #expect(input.isRepeatingTwice() == true)
    }

    @Test(arguments: [
        111,
        123123123,
        4236785428
    ]) func intIsRepeatingTwiceFalse(_ input: Int) {
        #expect(input.isRepeatingTwice() == false)
    }

    @Test(arguments: [
        111,
        123123123,
        121212
    ]) func intIsRepeatingThreeTimes(_ input: Int) {
        #expect(input.isRepeating() == true)
    }

    @Test(arguments: [
        11111,
        1212121212,
        123123123123123
    ]) func intIsRepeatingFiveTimes(_ input: Int) {
        #expect(input.isRepeating() == true)
    }

    @Test(arguments: [
        123,
        1234,
        1234567890,
        123123143,
        122212
    ]) func intIsRepeatingFalse(_ input: Int) {
        #expect(input.isRepeating() == false)
    }

    @Test(arguments: [
        (4, 1),
        (14, 2),
        (12345, 5)
    ]) func intDigitsLength(_ arg: (input: Int, expected: Int)) {
        let input = arg.0
        let expected = arg.1

        #expect(input.digitsCount() == expected)
    }
}
