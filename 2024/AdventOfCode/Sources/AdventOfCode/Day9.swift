import Foundation

struct Day9: Challenge {
    var useExampleInput: Bool {
        false
    }

    func execute(
        withInput input: String,
        log: (String, Any?) -> Void
    ) throws {
        log("Day9", nil)

        log("Input", input)

        let expandedInput = expand(input)
        log("Expanded", printFragments(expandedInput))

        let compactedInput = compact(input: expandedInput)
        log("Compacted", printFragments(compactedInput))

        let checkSum = self.checksum(from: compactedInput)
        log("Checksum", checkSum)

        func printFragments(_ input: [Fragment]) -> String {
            input.map({ $0.toString() }).joined()
        }
    }

    func expand(
        _ diskmap: String
    ) -> [Fragment] {

        var id: Int = 0
        var isFreeSpace: Bool = false

        return (0..<diskmap.count)
            .reduce(into: []) { partialResult, charIdx in
                let charIndex = diskmap.index(diskmap.startIndex, offsetBy: charIdx)
                guard let firstDigit = Int(diskmap[charIndex...charIndex]) else {
                    return
                }

                let fragment = Fragment(
                    size: firstDigit,
                    kind: isFreeSpace ? .freeSpace : .file(id)
                )

                id += isFreeSpace ? 0 : 1
                isFreeSpace = !isFreeSpace

                return partialResult.append(fragment)
            }
    }

    func compact(input: [Fragment]) -> [Fragment] {
        guard var lastFragmentID = input.last(where: { $0.kind != .freeSpace })?.kind.fileId else {
            return input
        }

        var newInput = input
        while lastFragmentID >= 0 {
            if let fragmentIdx = newInput.firstIndex(where: { $0.kind.fileId == lastFragmentID }) {
                let fragment = newInput[fragmentIdx]

                if let freeFragmentIdx = newInput.firstIndex(where: { $0.kind == .freeSpace && $0.size >= fragment.size }), freeFragmentIdx < fragmentIdx {
                    newInput.replaceSubrange(fragmentIdx...fragmentIdx, with: [Fragment(size: fragment.size, kind: .freeSpace)])
                    newInput.replaceSubrange(freeFragmentIdx...freeFragmentIdx, with: newInput[freeFragmentIdx].insert(other: fragment))
                }
            }

            lastFragmentID -= 1
        }

        return newInput
    }

    func checksum(from input: [Fragment]) -> Int {
        var cumulSize = 0

        return input.reduce(0) { partialResult, frag in
            let charSum = if let fileID = frag.kind.fileId {
                fileID * (0..<frag.size).reduce(0) { $0 + cumulSize + $1 }
            } else {
                0
            }

            cumulSize += frag.size

            return partialResult + charSum
        }
    }

    func checksumFromIntList(_ input: [Int?]) -> Int {
        (0..<input.count)
            .reduce(into: 0) { partialResult, idx in
                let value = input[idx]

                partialResult += idx * (value ?? 0)
            }
    }

    typealias FileID = Int

    struct Fragment {
        enum Kind: Equatable {
            case freeSpace
            case file(FileID)

            var fileId: FileID? {
                guard case let .file(fileID) = self else {
                    return nil
                }
                return fileID
            }
        }

        let size: Int
        let kind: Kind

        func insert(other fragment: Fragment) -> [Fragment] {
            guard size >= fragment.size else {
                return [fragment]
            }

            return [
                fragment,
                Fragment(size: size - fragment.size, kind: .freeSpace)
            ]
        }

        func toString() -> String {
            let char = kind.fileId.map(String.init) ?? "."

            return String(repeating: char, count: size)
        }
    }
}

extension [Int?] {
    mutating func swapAt(lIdx: Int, rIdx: Int) {
        let lChar = self[lIdx]
        let rChar = self[rIdx]

        self[lIdx] = rChar
        self[rIdx] = lChar
    }
}
