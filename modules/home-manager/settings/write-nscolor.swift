import AppKit
import CoreFoundation
import Darwin
import Foundation

let usage = "usage: write-nscolor DOMAIN KEY '#RRGGBB'"

enum NSColorWriterError: LocalizedError {
    case invalidArguments
    case invalidColor(String)
    case archiveFailed(String)
    case preferencesWriteFailed(String)

    var errorDescription: String? {
        switch self {
        case .invalidArguments:
            usage
        case let .invalidColor(value):
            "Invalid color '\(value)'; expected #RRGGBB."
        case let .archiveFailed(description):
            "Could not archive color: \(description)"
        case let .preferencesWriteFailed(domain):
            "Could not write color to preferences domain \(domain)."
        }
    }

    var exitCode: Int32 {
        switch self {
        case .invalidArguments, .invalidColor:
            EX_USAGE
        case .archiveFailed, .preferencesWriteFailed:
            EXIT_FAILURE
        }
    }
}

func run() throws {
    let arguments = CommandLine.arguments
    guard arguments.count == 4 else {
        throw NSColorWriterError.invalidArguments
    }

    let domain = arguments[1]
    let key = arguments[2]
    let colorString = arguments[3]
    let hex = colorString.dropFirst()

    guard
        colorString.utf8.count == 7,
        colorString.first == "#",
        let value = UInt32(hex, radix: 16)
    else {
        throw NSColorWriterError.invalidColor(colorString)
    }

    let red = CGFloat((value >> 16) & 0xff) / 255
    let green = CGFloat((value >> 8) & 0xff) / 255
    let blue = CGFloat(value & 0xff) / 255
    let color = NSColor(srgbRed: red, green: green, blue: blue, alpha: 1)

    let data: Data
    do {
        data = try NSKeyedArchiver.archivedData(
            withRootObject: color,
            // Secure coding validates the object graph without changing the archive format.
            requiringSecureCoding: true
        )
    } catch {
        throw NSColorWriterError.archiveFailed(error.localizedDescription)
    }

    CFPreferencesSetAppValue(key as CFString, data as CFData, domain as CFString)

    guard CFPreferencesAppSynchronize(domain as CFString) else {
        throw NSColorWriterError.preferencesWriteFailed(domain)
    }
}

do {
    try run()
} catch let error as NSColorWriterError {
    FileHandle.standardError.write(Data("\(error.localizedDescription)\n".utf8))
    exit(error.exitCode)
} catch {
    FileHandle.standardError.write(Data("Unexpected error: \(error.localizedDescription)\n".utf8))
    exit(EXIT_FAILURE)
}
