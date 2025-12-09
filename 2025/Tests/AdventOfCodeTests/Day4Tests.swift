@testable import AdventOfCode
import Testing

struct Day4Tests {
    @Test func stringToMap() {
        let input = """
        ..@@
        @@..
        .@.@
        @.@.
        """

        let map = Day4.Map(input)

        #expect(map.size == .init(width: 4, height: 4))
        #expect(map.map == input.split(separator: "\n").map(String.init))
    }

    @Test func isRollOfPaperAtIndex() {
        let sut = Day4.Map("""
            ..
            @@
            """)

        #expect(sut.isRollOfPaper(at: .init(x: 1, y: 1)) == true)
    }

    @Test(arguments: [
        (0, Day4.Point(x: 0, y: 0)),
        (1, Day4.Point(x: 1, y: 0)),
        (2, Day4.Point(x: 0, y: 1)),
        (3, Day4.Point(x: 1, y: 1))
    ]) func mapIndexToPointConversion(_ args: (Int, Day4.Point)) {
        let sut = Day4.Map("""
            ..
            @@
            """)

        let input = args.0
        let expected = args.1

        #expect(sut.convertIndexToCoordinates(input) == expected)
    }

    @Test(arguments: [
        (Day4.Point(x: 1, y: 1), 3),
        (Day4.Point(x: 2, y: 0), 2),
        (Day4.Point(x: 3, y: 2), 1),
        (Day4.Point(x: 2, y: 3), 2)
    ]) func numberOfAdjacentRollOfPaper(_ args: (Day4.Point, Int)) {
        let sut = Day4()
        let map = Day4.Map("""
        ..@@
        @@..
        .@.@
        @.@.
        """)

        let input = args.0
        let expected = args.1

        #expect(sut.numberOfAdjacentRollOfPaper(at: input, in: map) == expected)
    }

    @Test func mapRemoveRollOfPaper() {
        var map = Day4.Map("""
        ..@@
        @@..
        .@.@
        @.@.
        """)

        map.removeRollOfPapers(at: [
            .init(x: 2, y: 0),
            .init(x: 0, y: 1),
            .init(x: 3, y: 2)
        ])

        #expect(map.map == [
            "...@",
            ".@..",
            ".@..",
            "@.@."
        ])
    }
}
