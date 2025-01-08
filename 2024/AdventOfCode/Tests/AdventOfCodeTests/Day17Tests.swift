import Testing
@testable import AdventOfCode

struct Day17Tests {
    @Test func test1() {
        var sut = Day17.Computer(regA: 0, regB: 0, regC: 9, program: [2, 6])

        sut.runProgram()

        #expect(sut.regB == 1)
    }

    @Test func test2() {
        var sut = Day17.Computer(regA: 10, regB: 0, regC: 0, program: [5, 0, 5, 1, 5, 4])

        sut.runProgram()

        #expect(sut.out == [0, 1, 2])
    }

    @Test func test3() {
        var sut = Day17.Computer(regA: 2024, regB: 0, regC: 0, program: [0,1,5,4,3,0])

        sut.runProgram()

        #expect(sut.out == [4,2,5,6,7,7,7,7,3,1,0])
        #expect(sut.regA == 0)
    }

    @Test func test4() {
        var sut = Day17.Computer(regA: 0, regB: 29, regC: 0, program: [1, 7])

        sut.runProgram()

        #expect(sut.regB == 26)
    }

    @Test func test5() {
        var sut = Day17.Computer(regA: 0, regB: 2024, regC: 43690, program: [4, 0])

        sut.runProgram()

        #expect(sut.regB == 44354)
    }
}
