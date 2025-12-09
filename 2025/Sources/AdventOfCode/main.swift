import Foundation

let day = Day5()
let isTesting = false
let dayIdentifier = day.identifier + (isTesting ? "-test" : "")
let fileName = dayIdentifier

guard let inputURL = Bundle.module.url(forResource: fileName, withExtension: "txt") else {
    print("Couldn't find file named \(fileName).txt")
    exit(1)
}

do {
    print("Running \(dayIdentifier)...")
    let start = Date()

    let result = try day.run(from: inputURL)

    print("\(dayIdentifier) - result:", result)
    print("Execution took \(Date().timeIntervalSince(start)) seconds to run")
} catch {
    print("Failed", error)
}
