
import Foundation
import Parsing

struct Day2: Challenge {
    var useExampleInput: Bool {
        false
    }

    var levelParser: some Parser<Substring, [Int]> {
        Many {
            Int.parser()
        } separator: {
            " "
        }
    }

    var reportParser: some Parser<Substring, [[Int]]> {
        Many {
            levelParser
        } separator: {
            "\n"
        }
    }

    func execute(
        withInput input: String,
        log: (String, Any?) -> Void
    ) throws {
        let input = try reportParser.parse(input)
        log("parsed input:", input)

        let safeReports = input
            .filter(isReportLooslySafe(_:))
//        log("Safe reports", safeReports)
        log("Unsafe reports", input.filter { !isReportSafe($0) })

        log("Safe reports count", safeReports.count)
    }

    func isReportLooslySafe(_ report: [Int]) -> Bool {
        (0..<report.count)
            .contains {
                var newReport = report
                newReport.remove(at: $0)

                return isReportSafe(newReport)
            }
    }

    func isReportSafe(_ report: [Int]) -> Bool {
        enum Trend {
            case increasing
            case decresing
        }

        enum Temp {
            case previous(Int, Trend?)
            case unsafe
        }

        let result = report.reduce(nil as Temp?) { partialResult, value in
            guard let partialResult else {
                return .previous(value, nil)
            }

            switch partialResult {
            case .unsafe: return partialResult

            case let .previous(pVal, trend):
                let delta = abs(pVal - value)
                if delta < 1 || delta > 3 {
                    return .unsafe
                }

                if pVal > value {
                    if trend == .increasing {
                        return .unsafe
                    }
                    return .previous(value, .decresing)
                } else {
                    if trend == .decresing {
                        return .unsafe
                    }
                    return .previous(value, .increasing)
                }
            }
        }

        return switch result {
        case .previous(_, .none):
            false
        case .previous:
            true
        case .unsafe:
            false
        case .none:
            false
        }
    }
}
