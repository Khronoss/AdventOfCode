import Foundation

/*
 RRRRIICCFF
 RRRRIICCCF
 VVRRRCCFFF
 VVRCCCJFFF
 VVVVCJJCFE
 VVIVCCJJEE
 VVIIICJJEE
 MIIIIIJJEE
 MIIISIJEEE
 MMMISSJEEE
 */
/*
 OOOOO
 OXOXO
 OOOOO
 OXOXO
 OOOOO
 */
/*
 AAAA
 BBCD
 BBCC
 EEEC
 */
struct Day12: Challenge {
    var useExampleInput: Bool {
        false
    }

    func execute(
        withInput input: String,
        log: (String, Any?) -> Void
    ) async throws {
        log("Day12", nil)

        let map = Map(input: input)
//        map.printRegions()

        let infos = map.regions
            .mapValues {
                $0.map { (map.sidesCount(for: $0), map.area(for: $0)) }
            }
//        log("Infos", infos)

        let prices = infos
            .mapValues {
                $0.map { $0.0 * $0.1 }
            }
//        log("Prices", prices)

        log("Total price", prices.reduce(0, { $0 + $1.value.reduce(0, +)} ))

//        map.printMap(highlighting: map.regions["T"]!)
    }

    struct Coordinate: Hashable, CustomStringConvertible {
        let x: Int
        let y: Int

        func isNextTo(_ other: Self) -> Bool {
            (y == other.y && (x + 1 == other.x || x - 1 == other.x)) ||
            (x == other.x && (y + 1 == other.y || y - 1 == other.y))
        }

        var description: String {
            "(\(x), \(y))"
        }

        func countFreeEdges(in region: [Coordinate]) -> Int {
            [(-1, 0), (0, 1), (1, 0), (0, -1)] // N E S W
                .filter { dir in
                    !region.contains(Coordinate(x: x + dir.0, y: y + dir.1))
                }
                .count
        }

        func hasNeihboor(dir: (Int, Int), in region: [Coordinate]) -> Bool {
            region.contains(Coordinate(x: x + dir.0, y: y + dir.1))
        }
    }

    enum Direction: CaseIterable {
        case north, east, south, west

        func countSides(in region: [Coordinate]) -> Int {
            filterAndSortExternalCells(in: region)
                .reduce(into: [[Coordinate]]()) { sides, cell in
                    guard let sideIndex = sides.firstIndex(where: { $0.last?.isNextTo(cell) ?? false }) else {
                        return sides.append([cell])
                    }
                    sides[sideIndex] = sides[sideIndex] + [cell]
                }
                .count
        }

        var coordinateOffset: (Int, Int) {
            switch self {
            case .north: (0, -1)
            case .east: (1, 0)
            case .south: (0, 1)
            case .west: (-1, 0)
            }
        }

        func filterAndSortExternalCells(in region: [Coordinate]) -> [Coordinate] {
            let sortClosure: (Day12.Coordinate, Day12.Coordinate) -> Bool = switch self {
            case .north, .south: { lhs, rhs in
                lhs.y < rhs.y && lhs.x < rhs.x
            }
            case .east, .west: { lhs, rhs in
                lhs.y < rhs.y || (lhs.y == rhs.y && lhs.x < rhs.x)
            }
            }

            return filterExternalCells(in: region)
                .sorted(by: sortClosure)
        }

        func filterExternalCells(in region: [Coordinate]) -> [Coordinate] {
            region
                .filter { !$0.hasNeihboor(dir: coordinateOffset, in: region) }
        }
    }

    struct Map {
        let width: Int
        let height: Int
        let regions: [Character: [[Coordinate]]]
        let lines: [String]

        init(input: String) {
            let lines = input.split(separator: "\n")
            let width = lines.first?.count ?? 0
            let height = lines.count

            var regions: [Character: [[Coordinate]]] = [:]

            for y in 0..<height {
                let line = lines[y]

                var lineRegions: [Character: [[Coordinate]]] = [:]
                for x in 0..<width {
                    let character = line.getChar(at: x)
                    let coordinate = Coordinate(x: x, y: y)

                    if var regionsList = lineRegions[character] {
                        if let touchingRegionIdx = regionsList.firstIndex(where: { $0.contains(where: { $0.isNextTo(coordinate) }) }) {
                            regionsList[touchingRegionIdx].append(coordinate)
                        } else {
                            regionsList.append([coordinate])
                        }
                        lineRegions[character] = regionsList
                    } else {
                        lineRegions[character] = [[coordinate]]
                    }
                }

                regions.merge(lineRegions) { previousLineRegion, newLineRegions in
                    newLineRegions
                        .reduce(into: previousLineRegion) { partialResult, region in
                            if let previousRegionIdx = partialResult.firstIndex(where: { previousLineRegion in
                                previousLineRegion.contains(where: { cell in
                                    region.contains(where: { other in
                                        cell.isNextTo(other)
                                    })
                                })
                            }) {
                                partialResult[previousRegionIdx] = partialResult[previousRegionIdx] + region
                            } else {
                                partialResult.append(region)
                            }
                        }
                }
            }

            // merge contiguous regions
            regions = regions.mapValues { regionsList in
                regionsList.reduce(into: [[Day12.Coordinate]]()) { newRegionsList, region in
                    if let contiguousRegionIdx = newRegionsList.firstIndex(where: { newRegion in region.isContiguous(to: newRegion) }) {
                        newRegionsList[contiguousRegionIdx] = newRegionsList[contiguousRegionIdx] + region
                    } else {
                        newRegionsList.append(region)
                    }
                }
            }

            self.width = width
            self.height = height
            self.regions = regions
            self.lines = lines.map(String.init)

            print("Input chars count:", lines.reduce(0) { $0 + $1.count })
            print("Regions cells count:", regions.reduce(0) { $0 + $1.value.reduce(0) { $0 + $1.count } })
            print("Regions count:", regions.reduce(0) { $0 + $1.value.count })
        }

        func printRegions() {
            regions.forEach { (name, regions) in
//                print("Region \(name):", regions.map(\.count))
                print("Region \(name):")
                regions.forEach { region in
                    print(
                        "P=\(perimeter(for: region))",
                        "A=\(area(for: region))",
                        region
                    )
                }
            }
        }

        func area(for region: [Coordinate]) -> Int {
            region.count
        }

        func perimeter(for region: [Coordinate]) -> Int {
            region.reduce(0) { $0 + $1.countFreeEdges(in: region) }
        }

        func sidesCount(for region: [Coordinate]) -> Int {
            Direction
                .allCases
                .reduce(0) { $0 + $1.countSides(in: region) }
        }

        func printMap(highlighting regions: [[Day12.Coordinate]]) {
            let mapChar = "abcdefghijklmnopqrstuvwxyz" + "abcdefghijklmnopqrstuvwxyz".uppercased()

            (0..<height).forEach { y in
                let lineToPrint = (0..<width).reduce(into: "") { newLine, x in
                    if let index = regions.firstIndex(where: { region in region.contains(.init(x: x, y: y)) }) {
                        newLine += String(mapChar.getChar(at: index))
                    } else {
                        newLine += "."
                    }
                }

                print(lineToPrint)
            }
        }
    }
}

extension StringProtocol {
    func getChar(at index: Int) -> Character {
        self[self.index(startIndex, offsetBy: index)]
    }
}

extension [Day12.Coordinate] {
    func isContiguous(to other: Self) -> Bool {
        contains(where: { cell in other.contains { otherCell in cell.isNextTo(otherCell) } })
    }
}
