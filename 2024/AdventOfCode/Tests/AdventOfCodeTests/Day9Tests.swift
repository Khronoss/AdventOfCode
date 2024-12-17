import Testing
@testable import AdventOfCode

struct Day9Tests {

    @Test(arguments: [
        ("12345", "0..111....22222"),
        ("2333133121414131402", "00...111...2...333.44.5555.6666.777.888899")
    ]) func expandDiskMap(diskmap: String, expanded: String) async throws {
        let sut = Day9()

        #expect(sut.expand(diskmap) == expanded)
    }

    @Test(arguments: [
        ("0..111....22222", "022111222......"),
        ("00...111...2...333.44.5555.6666.777.888899", "0099811188827773336446555566..............")
    ]) func compactInput(_ input: String, compacted: String) async throws {
        let sut = Day9()

        #expect(sut.compact(input: input) == compacted)
    }

    @Test func checksum() async throws {
        let sut = Day9()

        #expect(sut.checksum(from: "0099811188827773336446555566..............") == 1928)
    }
}
