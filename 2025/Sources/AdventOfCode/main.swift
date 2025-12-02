import Foundation

let day = Day2()
let fileName = day.identifier

guard let inputURL = Bundle.module.url(forResource: fileName, withExtension: "txt") else {
    print("Couldn't find file named \(fileName).txt")
    exit(1)
}

do {
    let result = try day.run(from: inputURL)

    print("\(day.identifier) - result:", result)
} catch {
    print("Failed", error)
}
