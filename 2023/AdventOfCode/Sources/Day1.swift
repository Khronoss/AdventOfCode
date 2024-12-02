import Foundation

enum Day1 {
    static func execute() -> [String] {
        var output: [String] = [
            "-- Day1 --"
        ]

        do {
            let lines = try FileReader()
                .lines(fromFile: "Day1")

            if let result = calibration(forLines: lines) {
                output.append(
                    "Part1 result: \(result)"
                )
            } else {
                output.append(
                    "Part1: something bad happened"
                )
            }
        } catch {
            output.append(
                "Part1: something bad happened - \(error)"
            )
        }

        return output
    }

    static func calibration(
        forLines lines: [String]
    ) -> Int? {
        let calibrations = lines
            .compactMap(Self.calibration(for:))

        return addCalibrations(calibrations)
    }

    static func calibration(
        for line: String
    ) -> Int? {
        let possibleValues = [
            1, 2, 3, 4, 5, 6, 7, 8, 9
        ]
            .map(String.init)

        guard let firstDigits = line.first(where: {
            CharacterSet
                .decimalDigits
                .contains($0.unicodeScalars.first!)
        }) else {
            return nil
        }

        guard let secondDigit = line.reversed().first(where: {
            CharacterSet
                .decimalDigits
                .contains($0.unicodeScalars.first!)
        }) else {
            return nil
        }

        return Int("\(firstDigits)\(secondDigit)")
    }

    static func addCalibrations(
        _ calibrations: [Int]
    ) -> Int {
        calibrations.reduce(0, +)
    }
}
