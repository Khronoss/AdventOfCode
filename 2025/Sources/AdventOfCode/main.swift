import Foundation

let day = Day1()
let fileName = day.identifier + "-1"

guard let inputURL = Bundle.module.url(forResource: fileName, withExtension: "txt") else {
    print("Couldn't find file named \(fileName).txt")
    exit(1)
}

do {
    let result = try day.runPart1(from: inputURL)

    print("\(day.identifier) - result:", result)
} catch {
    print("Failed", error)
}
