//
//  Test.swift
//  AdventOfCode
//
//  Created by Anthony MERLE on 16/12/2024.
//

import Testing
@testable import AdventOfCode

struct Day7Tests {

    @Test func factorsParser() async throws {
        #expect(try Day7.FactorsParser().parse("1 2 3 4 5") == [1, 2, 3, 4, 5])
    }

    @Test func equationParser() async throws {
        #expect(
            try Day7.EquationParser().parse("3267: 81 40 27") == Day7.Equation(testValue: 3267, factors: [81, 40, 27])
        )
    }

    @Test func equationsParser() async throws {
        let expectation: [Day7.Equation] = [
            .init(testValue: 190, factors: [10, 19]),
            .init(testValue: 3267, factors: [81, 40, 27]),
            .init(testValue: 83, factors: [17, 5]),
            .init(testValue: 156, factors: [15, 6])
        ]

        #expect(
            try Day7().parser.parse("""
            190: 10 19
            3267: 81 40 27
            83: 17 5
            156: 15 6
            """) == expectation
        )
    }

    @Test(
        arguments: processInputs
    )
    func process(input: [Int], expectedResult: [Int]) async throws {
        let sut = Day7()

        #expect(sut.process(input: input) == expectedResult)
    }

    static var processInputs: [([Int], [Int])] {
        [
            ([Int](), []),
            ([19], [19]),
            ([10, 19], [29, 190, 1019]),
            ([81, 40, 27], [
                (81 + 40) + 27,
                (81 + 40) * 27,
                Day7.concat((81 + 40), 27),

                (81 * 40) + 27,
                (81 * 40) * 27,
                Day7.concat((81 * 40), 27),

                (8140) + 27,
                (8140) * 27,
                814027
            ])
        ]
    }
}
