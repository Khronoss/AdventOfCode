// The Swift Programming Language
// https://docs.swift.org/swift-book
// 
// Swift Argument Parser
// https://swiftpackageindex.com/apple/swift-argument-parser/documentation

import ArgumentParser
import Foundation

@main
struct AdventOfCode: ParsableCommand {

    mutating func run() throws {
        print("Hello, world!")

        trace {
            let challenge = Day5()
            let runner = ChallengeRunner()

            runner.run(challenge, logger: printMsg)
        }
    }

    func trace(_ operation: () -> Void) {
        let start = Date()
        operation()
        let end = Date()

        printMsg(
            message: "Execution time",
            value: end.timeIntervalSince(start)
        )
    }

    func printMsg(message: String, value: Any?) {
        if let value {
            print(message, value)
        } else {
            print(message)
        }
    }
}
