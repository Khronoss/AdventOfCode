import Foundation

// Part1 : 213625

struct Day11: Challenge {
    var useExampleInput: Bool {
        false
    }

    func execute(
        withInput input: String,
        log: (String, Any?) -> Void
    ) async throws {
        log("Day11", nil)

        let stones = input
            .split(separator: " ")
            .map(Stone.init(input:))
            .reduce(into: [:], { $0[$1] = 1 })

        log("Stones", stones)

        let step = 75
        let newStones = processStones(stones, steps: step)
        log("Stones count", newStones.values.reduce(0, +))
    }

    func processStones(
        _ stones: [Stone: Int],
        steps: Int
    ) -> [Stone: Int] {
        (0..<steps)
            .reduce(stones) { partialResult, step in
                print("Step", step)
                return update(partialResult)
        }
    }

    func update(_ stones: [Stone: Int]) -> [Stone: Int] {
        stones.reduce(into: [:]) { newStones, stone in
            let updatedStones = stone.key.update()

            for updatedStone in updatedStones {
                newStones[updatedStone] = (newStones[updatedStone] ?? 0) + stone.value
            }
        }
    }

    struct Stone: Hashable, CustomStringConvertible {
        let value: Int

        func update() -> [Stone] {
            if value == 0 {
                return [Stone(value: 1)]
            }

            let stringValue = String(value)

            if stringValue.count.isMultiple(of: 2) {
                return [
                    Stone(input: stringValue[..<stringValue.middPointIndex]),
                    Stone(input: stringValue[stringValue.middPointIndex...])
                ]
            }

            return [Stone(value: value * 2024)]
        }

        var description: String {
            "\(value)"
        }
    }
}

extension Day11.Stone {
    init(input: some StringProtocol) {
        self.value = Int(input)!
    }
}

extension String {
    var middPointIndex: Self.Index {
        index(startIndex, offsetBy: count / 2)
    }
}
