@testable import AdventOfCode
import XCTest

final class AoCDay1Tests: XCTestCase {

    // MARK: - Part1
    func test_lineWithTwoDigits() {
        XCTAssertEqual(
            Day1.calibration(for: "1abc2"),
            12
        )
    }

    func test_lineWithTwoDigitsInTheMiddle() {
        XCTAssertEqual(
            Day1.calibration(for: "pqr3stu8vwx"),
            38
        )
    }

    func test_lineWithMoreThanTwoDigits() {
        XCTAssertEqual(
            Day1.calibration(for: "a1b2c3d4e5f"),
            15
        )
    }

    func test_lineWithOneDigit() {
        XCTAssertEqual(
            Day1.calibration(for: "treb7uchet"),
            77
        )
    }

    func test_addCalibrations() {
        XCTAssertEqual(
            Day1.addCalibrations(
                [12, 38, 15, 77]
            ),
            142
        )
    }

    func test_multipleLinesCalibration() {
        XCTAssertEqual(
            Day1.calibration(forLines: [
                "1abc2",
                "pqr3stu8vwx",
                "a1b2c3d4e5f",
                "treb7uchet"
            ]),
            142
        )
    }

    // MARK: - Part2
    func test_multipleLinesCalibration_2() {
        XCTAssertEqual(
            Day1.calibration(forLines: [
                "two1nine",
                "eightwothree",
                "abcone2threexyz",
                "xtwone3four",
                "4nineeightseven2",
                "zoneight234",
                "7pqrstsixteen"
            ]),
            281
        )
    }
}
