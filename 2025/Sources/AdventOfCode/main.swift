import Foundation

let day = Day2()
let fileName = day.identifier

guard let inputURL = Bundle.module.url(forResource: fileName, withExtension: "txt") else {
    print("Couldn't find file named \(fileName).txt")
    exit(1)
}

do {
    print("Running \(day.identifier)...")
    let start = Date()

    let result = try day.run(from: inputURL)

    print("\(day.identifier) - result:", result)
    print("Execution took \(Date().timeIntervalSince(start)) seconds to run")
} catch {
    print("Failed", error)
}
