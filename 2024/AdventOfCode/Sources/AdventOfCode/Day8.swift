import Foundation

struct Day8: Challenge {
    var useExampleInput: Bool {
        false
    }

    func execute(
        withInput input: String,
        log: (String, Any?) -> Void
    ) async throws {
        log("Day8", nil)
        let map = getMap(from: input)

        let signals = map.antennas
            .flatMap { (_, antennas) in
                getFrequencies(from: antennas, in: map)
            }
            .filter {
                !map.isOutOfBounds($0)
            }

        log("Map size", map.size)
        log("Signals", signals.sorted(by: { $0.y < $1.y }))
        log("Unique Signal count", Set(signals).count)

        printMap(map, signals: signals)
    }

    func printMap(_ map: Map, signals: [Frequency]) {
        (0..<map.size.height).forEach { y in
            let line = (0..<map.size.width).map { x in
                let antenna = Antenna(x: x, y: y)
                let freq = Frequency(x: x, y: y)

                if signals.contains(freq) {
                    return "#" as Character
                } else if let antennas = map.antennas.first(where: { (key, antenas) in
                    antenas.contains(antenna)
                }) {
                    return antennas.key
                } else {
                    return "."
                }
            }

            print(String(line))
        }
    }

    func getMap(from input: String) -> Map {
        let lines = input.split(separator: "\n")
        let size = Size(width: lines.first?.count ?? 0, height: lines.count)

        var antennas: [Character: [Antenna]] = [:]
        for y in (0..<size.height) {
            let line = lines[y]
            for x in (0..<size.width) {
                let char = line[line.index(line.startIndex, offsetBy: x)]
                guard char != "." else {
                    continue
                }

                var newAntennas = antennas[char] ?? []
                newAntennas.append(Antenna(x: x, y: y))

                antennas[char] = newAntennas
            }
        }

        return Map(
            size: size,
            antennas: antennas
        )
    }

    func getFrequencies(from antennas: [Antenna], in map: Map) -> [Frequency] {
        guard antennas.count > 1 else {
            return []
        }

        let head = antennas[0]
        let tail = antennas[1..<antennas.count]

        return tail.flatMap { rhs in
            getFrequencies(from: head, and: rhs, in: map)
        } + getFrequencies(from: Array(tail), in: map)
    }

    func getFrequencies(from lhs: Antenna, and rhs: Antenna, in map: Map) -> [Frequency] {
        let xStep = rhs.x - lhs.x
        let yStep = rhs.y - lhs.y

        var frequencies: [Frequency] = []

        var newFrequency = Frequency(x: lhs.x, y: lhs.y)
        while !map.isOutOfBounds(newFrequency) {
            frequencies.append(newFrequency)
            newFrequency = Frequency(x: newFrequency.x - xStep, y: newFrequency.y - yStep)
        }

        newFrequency = Frequency(x: rhs.x, y: rhs.y)
        while !map.isOutOfBounds(newFrequency) {
            frequencies.append(newFrequency)
            newFrequency = Frequency(x: newFrequency.x + xStep, y: newFrequency.y + yStep)
        }
        
        return frequencies
    }

    struct Size: Equatable {
        let width: Int, height: Int
    }

    struct Antenna: Equatable {
        let x: Int, y: Int
    }

    struct Frequency: Hashable {
        let x: Int, y: Int
    }

    struct Map {
        let size: Day8.Size
        let antennas: [Character: [Antenna]]

        func isOutOfBounds(_ freq: Day8.Frequency) -> Bool {
            freq.x < 0 || freq.y < 0 || freq.x >= size.width || freq.y >= size.height
        }
    }
}
