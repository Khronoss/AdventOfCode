import Foundation
import Parsing

struct Day3: Challenge {
    var useExampleInput: Bool {
        false
    }

    func execute(
        withInput input: String,
        log: (String, Any?) -> Void
    ) async throws {
        //            let regex = /mul\((\d{1,3}),(\d{1,3})\)/
        let regex = /(mul\((\d{1,3}),(\d{1,3})\))|do\(\)|don't\(\)/

        //            let result = file
        //                .matches(of: regex)
        //                .map { match in
        //                    Int(match.1)! * Int(match.2)!
        //                }
        //                .reduce(0, +)
        struct Temp {
            var skip = false
            var total = 0
        }

        let result = input
            .matches(of: regex)
            .reduce(into: Temp()) { partialResult, match in
                switch match.output.0 {
                case "do()": partialResult.skip = false
                case "don't()": partialResult.skip = true
                default:
                    if partialResult.skip {
                        return
                    }
                    partialResult.total += Int(match.2!)! * Int(match.3!)!
                }
            }

        log("Result", result)
    }
}
