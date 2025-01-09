import Foundation
import Parsing

struct Day17: Challenge {
    var useExampleInput: Bool {
        false
    }

    func execute(
        withInput input: String,
        log: (String, Any?) -> Void
    ) async throws {
        log("Day 17", nil)

        let computer = try ComputerParser().parse(input)
        log("Computer", computer)

        // Part 1
        var part1Comp = computer
        part1Comp.runProgram()
        log("Out", part1Comp.outString)

        // Part 2
        var len = computer.program.count - 1
        var inRegA = intPow(8, len)
        var found = false

        len -= 1

        log("Part 2: Start RegA", inRegA)
        while !found {
            var part2Comp = computer
            part2Comp.regA = inRegA
            part2Comp.runProgram()

            if part2Comp.out[len+1] == computer.program[len+1] {
                if part2Comp.out == computer.program {
                    log("Part 2 Out", part2Comp.outString)
                    found = true
                } else if len == 0 {
                    inRegA += 1
                }

                if len > 0 {
                    len -= 1
                }

            } else {
                inRegA += intPow(8, len)
            }
        }
        log("Part 2: stopped RegA", inRegA)

        // Start = 35184372088832
        // End = 107905300916634
        // Possible solutions: 72_720_928_827_802
        // End solution: 105706277661082
    }

    enum Instruction {
        static var allInstructions: [(inout Computer) -> Void] {
            [
                Instruction.adv(_:),
                Instruction.bxl(_:),
                Instruction.bst(_:),
                Instruction.jnz(_:),
                Instruction.bxc(_:),
                Instruction.out(_:),
                Instruction.bdv(_:),
                Instruction.cdv(_:)
            ]
        }

        static func adv(_ computer: inout Computer) {
            let numerator = computer.regA
            let denominator = intPow(2, computer.comboOperand)

            computer.regA = numerator / denominator
            computer.instructionPntr += 2
        }

        static func bxl(_ computer: inout Computer) {
            computer.regB = computer.regB ^ computer.operand
            computer.instructionPntr += 2
        }

        static func bst(_ computer: inout Computer) {
            computer.regB = ((computer.comboOperand % 8) + 8) % 8
            computer.instructionPntr += 2
        }

        static func jnz(_ computer: inout Computer) {
            if computer.regA == 0 {
                computer.instructionPntr += 2
                return
            }
            computer.instructionPntr = computer.operand
        }

        static func bxc(_ computer: inout Computer) {
            computer.regB = computer.regB ^ computer.regC
            computer.instructionPntr += 2
        }

        static func out(_ computer: inout Computer) {
            computer.out.append(((computer.comboOperand % 8) + 8) % 8)
            computer.instructionPntr += 2
        }

        static func bdv(_ computer: inout Computer) {
            let numerator = computer.regA
            let denominator = intPow(2, computer.comboOperand)

            computer.regB = numerator / denominator
            computer.instructionPntr += 2
        }

        static func cdv(_ computer: inout Computer) {
            let numerator = computer.regA
            let denominator = intPow(2, computer.comboOperand)

            computer.regC = numerator / denominator
            computer.instructionPntr += 2
        }
    }

    struct Computer {
        var regA: Int
        var regB: Int
        var regC: Int

        let program: [Int]
        var instructionPntr: Int
        var out: [Int]

        var outString: String {
            out.map(String.init).joined(separator: ",")
        }

        init(regA: Int, regB: Int, regC: Int, program: [Int], instructionPntr: Int) {
            self.regA = regA
            self.regB = regB
            self.regC = regC
            self.program = program
            self.instructionPntr = instructionPntr
            self.out = []
        }

        init(regA: Int, regB: Int, regC: Int, program: [Int]) {
            self.regA = regA
            self.regB = regB
            self.regC = regC
            self.program = program
            self.instructionPntr = 0
            self.out = []
        }

        var operand: Int {
            program[instructionPntr + 1]
        }

        var comboOperand: Int {
            switch operand {
            case 0...3: operand
            case 4: regA
            case 5: regB
            case 6: regC
            default: 0 // invalid
            }
        }

        mutating
        func runProgram() {
            let instructions = Instruction.allInstructions

            while instructionPntr < program.count {
                let instruction = instructions[program[instructionPntr]]
                instruction(&self)
            }
        }
    }

    struct ComputerParser: Parser {
        var body: some Parser<Substring, Computer> {
            Parse(Computer.init) {
                RegisterParser(id: "A")
                RegisterParser(id: "B")
                RegisterParser(id: "C")
                Whitespace(.vertical)
                ProgramParser()
            }
        }
    }

    struct RegisterParser: Parser {
        let id: String

        var body: some Parser<Substring, Int> {
            "Register \(id): "
            Int.parser()
            Whitespace(.vertical)
        }
    }

    struct ProgramParser: Parser {
        var body: some Parser<Substring, [Int]> {
            "Program: "
            Many {
                Int.parser()
            } separator: {
                ","
            }
        }
    }
}

func intPow(_ a: Int, _ b: Int) -> Int {
    (pow(Decimal(a), b) as NSDecimalNumber).intValue
}
