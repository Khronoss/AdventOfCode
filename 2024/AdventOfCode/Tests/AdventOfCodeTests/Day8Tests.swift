import Testing
@testable import AdventOfCode

struct Day8Tests {

    @Test func extractAntenasFromMap() async throws {
        let sut = Day8()

        let map = sut.getMap(from: """
        ....
        .A..
        ...0
        .0..
        ...a
        """)

        #expect(map.size == Day8.Size(width: 4, height: 5))
        #expect(map.antennas == [
            "A": [
                Day8.Antenna(x: 1, y: 1)
            ],
            "0": [
                Day8.Antenna(x: 3, y: 2),
                Day8.Antenna(x: 1, y: 3)
            ],
            "a": [
                Day8.Antenna(x: 3, y: 4)
            ]
        ])
    }

    @Test(
        arguments: [
            ([
                Day8.Antenna(x: 3, y: 2),
                Day8.Antenna(x: 1, y: 3)
            ],
             [
                Day8.Frequency(x: 5, y: 1),
                Day8.Frequency(x: -1, y: 4)
             ]),
            ([
                Day8.Antenna(x: 3, y: 3),
                Day8.Antenna(x: 1, y: 2)
            ],
             [
                Day8.Frequency(x: 5, y: 4),
                Day8.Frequency(x: -1, y: 1)
             ]),
            ([
                Day8.Antenna(x: 1, y: 2),
                Day8.Antenna(x: 3, y: 3)
            ],
             [
                Day8.Frequency(x: -1, y: 1),
                Day8.Frequency(x: 5, y: 4)
             ])
        ]
    )
    func getFrequencies(
        _ antennas: [Day8.Antenna],
        expectedFreqs: [Day8.Frequency]
    ) async throws {
        let sut = Day8()
        
        let freqs = sut.getFrequencies(
            from: antennas[0],
            and: antennas[1],
            in: Day8.Map(size: Day8.Size(width: 4, height: 5), antennas: [:])
        )

        #expect(freqs == expectedFreqs)
    }

    @Test func getFrequenciesFromManyAntennas() {
        let sut = Day8()

        let frequencies = sut.getFrequencies(
            from: [
                Day8.Antenna(x: 3, y: 2),
                Day8.Antenna(x: 1, y: 3),
                Day8.Antenna(x: 1, y: 1)
            ],
            in: Day8.Map(size: Day8.Size(width: 4, height: 5), antennas: [:])
        )

        #expect(frequencies == [
            Day8.Frequency(x: 5, y: 1),
            Day8.Frequency(x: -1, y: 4),

            Day8.Frequency(x: 5, y: 3),
            Day8.Frequency(x: -1, y: 0),

            Day8.Frequency(x: 1, y: 5),
            Day8.Frequency(x: 1, y: -1)
        ])
    }
}
