//
//  PriorityQueueTests.swift
//  AdventOfCode
//
//  Created by Anthony MERLE on 07/01/2025.
//

import Testing
@testable import AOCTools

struct PriorityQueueTests {
    @Test
    func emptyQueue() throws {
        let sut = PriorityQueue<Int>()

        #expect(sut.array == [])
    }

    @Test
    func insertElement() throws {
        var sut = PriorityQueue<Int>()

        let array = [6, 5, 3, 1, 8, 7, 2, 4]

        array.forEach { sut.insert($0) }
        #expect(sut.array == [8, 6, 7, 4, 5, 3, 2, 1])
    }

    @Test
    func popElement() throws {
        var sut = PriorityQueue<Int>()
        sut.array = [8, 6, 7, 4, 5, 3, 2, 1]

        let minVal = sut.pop()
        #expect(minVal == 8)
        #expect(sut.array == [7, 6, 3, 4, 5, 1, 2])
    }
}
