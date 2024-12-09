//
//  Challenge.swift
//  AdventOfCode
//
//  Created by Anthony MERLE on 09/12/2024.
//

import Foundation

protocol Challenge {
    var useExampleInput: Bool { get }
    var fileName: String { get }

    func execute(
        withInput input: String,
        log: (String, Any?) -> Void
    ) throws
}

extension Challenge {
    var fileName: String {
        if useExampleInput {
            "\(Self.self)_example"
        } else {
            "\(Self.self)_input"
        }
    }
}

struct ChallengeRunner {
    func run<C: Challenge>(
        _ challenge: C,
        logger: (String, Any?) -> Void
    ) {
        do {
            let file = try FileReader()
                .readFile(challenge.fileName)

            try challenge.execute(withInput: file, log: logger)
        } catch {
            logger("Failed running challenge \(C.self)", error)
        }
    }
}
