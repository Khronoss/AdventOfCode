// The Swift Programming Language
// https://docs.swift.org/swift-book
// 
// Swift Argument Parser
// https://swiftpackageindex.com/apple/swift-argument-parser/documentation

import ArgumentParser
import Foundation

@main
struct AdventOfCode: AsyncParsableCommand {

    mutating func run() async throws {
        print("Hello, world!")

        let mainRunner = MainRunner()

        await mainRunner.trace {
            let challenge = Day11()
            let runner = ChallengeRunner()

            await runner.run(challenge, logger: mainRunner.printMsg)
        }
    }

}

struct MainRunner {
    func trace(_ operation: () async -> Void) async {
        print("Running challenge")

        let start = Date()
        await operation()
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
