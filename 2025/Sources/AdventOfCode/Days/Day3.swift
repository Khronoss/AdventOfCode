import Parsing
import Foundation

// TODO: Implement using Monotonic Stack

struct Day3 {
    let identifier = "Day3"

    func run(from filePath: URL) throws -> Int {
        let lines = try String(contentsOf: filePath, encoding: .utf8).split(separator: "\n")
        let banks = lines.map { $0.toListOfInt() }

        return maxJoltage(from: banks)
    }

    func maxJoltage(from banks: [[Int]]) -> Int {
        banks.reduce(0) { $0 + maxJoltage(from: $1) }
    }

    func maxJoltage(from bank: [Int]) -> Int {
        return maxJoltage_rec(bank: bank[0...], acc: 0, countDown: 12)
    }

    private func maxJoltage_rec(bank: ArraySlice<Int>, acc: Int, countDown: Int) -> Int {
        guard countDown > 0 else { return acc }

        let maxIndex = bank.index(bank.endIndex, offsetBy: -countDown)
        guard let offset = bank[...maxIndex].firstIndexOfMaxValue() else { return acc }
        let index = bank.index(bank.startIndex, offsetBy: offset)
        let value = bank[index]
        let tail = bank[(index+1)...]

        return maxJoltage_rec(
            bank: tail,
            acc: acc * 10 + value,
            countDown: countDown - 1
        )
    }
}

extension StringProtocol {
    func toListOfInt() -> [Int] {
        self.reduce(into: []) { list, char in
            list.append(Int(String(char))!)
        }
    }
}

extension RandomAccessCollection where Element == Int {
    func firstIndexOfMaxValue() -> Int? {
        enumerated()
            .min(by: { $0.element > $1.element || $0.offset < $1.offset })?
            .offset
    }
}
