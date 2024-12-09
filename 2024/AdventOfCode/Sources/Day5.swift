//
//  Day5.swift
//  AdventOfCode
//
//  Created by Anthony MERLE on 09/12/2024.
//

import Foundation
import Parsing

struct Day5: Challenge {
    struct Input {
        typealias Rule = (Int, Int)

        let rules: [Rule]
        let sections: [[Int]]
    }

    var useExampleInput: Bool {
        false
    }

    func execute(withInput input: String, log: (String, Any?) -> Void) throws {
        log("Day5", nil)

        let input = try InputParser().parse(input)
        log("Parsed content", input)

        let unorderedSections = input
            .sections
            .filter { section in
                !isSectionOrdered(section, rules: input.rules)
            }

        let orderedSections = unorderedSections
            .map { section in
                order(section, with: input.rules)
            }
        log("Ordered sections", orderedSections)
        log("Count", orderedSections.count)

        let midPointCumul = orderedSections
            .map { section in
                section[section.count / 2]
            }
            .reduce(0, +)
        log("Midpoint", midPointCumul)
    }

    func isSectionOrdered(_ section: [Int], rules: [Input.Rule]) -> Bool {
        (0..<section.count-1)
            .allSatisfy { idx in
                let sectionTail = section[(idx+1)...]
                let lookingRules = rules.filter { $0.1 == section[idx] && sectionTail.contains($0.0) }

                return lookingRules.isEmpty || lookingRules.contains { rule in
                    !sectionTail.contains(rule.0)
                }
            }
    }

    func order(_ section: [Int], with rules: [Input.Rule]) -> [Int] {
        section.sorted { left, right in
            if rules.contains(where: { $0.1 == left && $0.0 == right }) {
                false
            } else {
                true
            }
        }
    }
}

fileprivate struct InputParser: Parser {
    var body: some Parser<Substring, Day5.Input> {
        Parse(Day5.Input.init) {
            Many {
                ruleParser
            } separator: {
                "\n"
            }

            Whitespace()

            Many {
                Many {
                    Int.parser()
                } separator: {
                    ","
                }
            } separator: {
                "\n"
            }
        }
    }

    var ruleParser: some Parser<Substring, Day5.Input.Rule> {
        Parse {
            Int.parser()
            "|"
            Int.parser()
        }
    }
}
