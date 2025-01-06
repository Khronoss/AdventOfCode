//
//  PriorityQueue.swift
//  AdventOfCode
//
//  Created by Anthony MERLE on 07/01/2025.
//

public struct PriorityQueue<T> {
    public typealias ItemComparator = (T, T) -> Bool
    var array: [T] = []
    let comparator: ItemComparator

    public var count: Int { array.count }

    public init(comparator: @escaping ItemComparator) {
        self.comparator = comparator
    }

    public init(
        comparator: @escaping ItemComparator = { $0 > $1 }
    ) where T: Comparable {
        self.comparator = comparator
    }

    mutating
    public func insert(_ element: T) {
        array.append(element)
        // sift up
        siftUp(lastIndex)
    }

    mutating
    public func pop() -> T? {
        if count == 0 {
            return nil
        } else if count == 1 {
            return array.removeFirst()
        } else {
            array.swapAt(0, lastIndex)
            let item = array.removeLast()
            siftDown(0)
            return item
        }
    }

    mutating
    private func siftUp(_ index: Int) {
        var index = index

        while index > 0 {
            let parentIdx = parentIndex(of: index)
            if comparator(array[index], array[parentIdx]) {
                array.swapAt(parentIdx, index)
                index = parentIdx
            } else {
                return
            }
        }
    }

    mutating
    private func siftDown(_ index: Int) {
        let leftIdx = leftChild(of: index)
        let rightIdx = rightChild(of: index)

        var comp = index

        if count > leftIdx && comparator(array[leftIdx], array[comp]) {
            comp = leftIdx
        }
        if count > rightIdx && comparator(array[rightIdx], array[comp]) {
            comp = rightIdx
        }
        if comp != index {
            array.swapAt(index, comp)
            siftDown(comp)
        }
    }

    private var lastIndex: Int {
        array.count - 1
    }

    private func parentIndex(of idx: Int) -> Int {
        (idx - 1) / 2
    }

    private func leftChild(of idx: Int) -> Int {
        2 * idx + 1
    }

    private func rightChild(of idx: Int) -> Int {
        2 * idx + 2
    }
}
