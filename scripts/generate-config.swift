import AppKit
import Foundation

private let defaultDomain = "com.kagi.kagimacOS"
private let excludedSettings: Set<String> = [
    "NSToolbar Configuration BrowserToolbar",
    "NSToolbar Configuration BrowserCompactTabToolbar",
]
private let toolbarFields: Set<String> = [
    "TB Display Mode",
    "TB Icon Size Mode",
    "TB Is Shown",
    "TB Item Identifiers",
    "TB Size Mode",
]

private struct Options {
    var catalogPath: String?
    var domain = defaultDomain
    var inputPath: String?
    var outputPath: String?
    var includeDefaults = false
    var force = false
}

private enum GeneratorError: Error, CustomStringConvertible {
    case message(String)

    var description: String {
        switch self {
        case .message(let text): return text
        }
    }
}

private func usage() -> String {
    """
    Usage: orion-generate-config [options]

      --catalog PATH       Settings catalog JSON (set by the flake app)
      --domain DOMAIN      Preference domain (default: \(defaultDomain))
      --input PATH         Read a plist fixture instead of live preferences
      --output PATH        Write atomically instead of printing to stdout
      --include-defaults   Include values equal to catalog defaults
      --force              Replace an existing output file
      -h, --help           Show this help
    """
}

private func parseOptions() throws -> Options {
    var options = Options()
    var index = 1
    let arguments = CommandLine.arguments

    func value(after flag: String) throws -> String {
        guard index + 1 < arguments.count else {
            throw GeneratorError.message("Missing value for \(flag)")
        }
        index += 1
        return arguments[index]
    }

    while index < arguments.count {
        switch arguments[index] {
        case "--catalog": options.catalogPath = try value(after: arguments[index])
        case "--domain": options.domain = try value(after: arguments[index])
        case "--input": options.inputPath = try value(after: arguments[index])
        case "--output": options.outputPath = try value(after: arguments[index])
        case "--include-defaults": options.includeDefaults = true
        case "--force": options.force = true
        case "-h", "--help":
            print(usage())
            exit(0)
        default:
            throw GeneratorError.message("Unknown argument: \(arguments[index])")
        }
        index += 1
    }

    guard options.catalogPath != nil else {
        throw GeneratorError.message("Missing --catalog PATH")
    }
    if options.inputPath == nil && options.domain.isEmpty {
        throw GeneratorError.message("Preference domain cannot be empty")
    }
    if options.force && options.outputPath == nil {
        throw GeneratorError.message("--force requires --output")
    }
    return options
}

private func readDictionary(at path: String, json: Bool) throws -> [String: Any] {
    let data = try Data(contentsOf: URL(fileURLWithPath: path))
    let object: Any
    if json {
        object = try JSONSerialization.jsonObject(with: data)
    } else {
        object = try PropertyListSerialization.propertyList(from: data, options: [], format: nil)
    }
    guard let dictionary = object as? [String: Any] else {
        throw GeneratorError.message("Expected a dictionary in \(path)")
    }
    return dictionary
}

private func preferences(options: Options) throws -> [String: Any] {
    if let path = options.inputPath {
        return try readDictionary(at: path, json: false)
    }
    guard let domain = UserDefaults.standard.persistentDomain(forName: options.domain) else {
        throw GeneratorError.message("Preference domain does not exist: \(options.domain)")
    }
    return domain
}

private func isBoolean(_ number: NSNumber) -> Bool {
    CFGetTypeID(number) == CFBooleanGetTypeID()
}

private func equivalent(_ lhs: Any, _ rhs: Any) -> Bool {
    (lhs as AnyObject).isEqual(rhs)
}

private func isInteger(_ number: NSNumber) -> Bool {
    !isBoolean(number) && !["f", "d"].contains(String(cString: number.objCType))
}

private func validColor(_ value: String) -> Bool {
    value.range(of: "^#[0-9A-Fa-f]{6}$", options: .regularExpression) != nil
}

private func validate(name: String, setting: [String: Any], value: Any) throws {
    guard let type = setting["type"] as? String else {
        throw GeneratorError.message("Catalog entry for \(name) has no type")
    }

    let valid: Bool
    switch type {
    case "attrs": valid = value is [String: Any]
    case "bool": valid = (value as? NSNumber).map(isBoolean) ?? false
    case "color": valid = (value as? String).map(validColor) ?? false
    case "enum":
        valid = (setting["values"] as? [Any])?.contains { equivalent(value, $0) } ?? false
    case "float":
        valid = (value as? NSNumber).map {
            !isBoolean($0) && !isInteger($0) && $0.doubleValue.isFinite
        } ?? false
    case "int": valid = (value as? NSNumber).map(isInteger) ?? false
    case "list": valid = value is [Any]
    case "string": valid = value is String
    default: valid = false
    }
    guard valid else {
        throw GeneratorError.message("\(name) does not match catalog type \(type)")
    }

    if let range = setting["range"] as? [String: Any],
       let number = value as? NSNumber,
       let minimum = range["min"] as? NSNumber,
       let maximum = range["max"] as? NSNumber,
       (number.compare(minimum) == .orderedAscending || number.compare(maximum) == .orderedDescending) {
        throw GeneratorError.message("\(name) is outside the catalog range")
    }
}

private func nixString(_ value: String) throws -> String {
    var result = "\""
    for scalar in value.unicodeScalars {
        switch scalar.value {
        case 0x09: result += "\\t"
        case 0x0A: result += "\\n"
        case 0x0D: result += "\\r"
        case 0x22: result += "\\\""
        case 0x5C: result += "\\\\"
        case 0x00...0x1F, 0x7F:
            throw GeneratorError.message("String contains an unsupported control character")
        default:
            result.unicodeScalars.append(scalar)
        }
    }
    return result.replacingOccurrences(of: "${", with: "\\${") + "\""
}

private func colorHex(from data: Data) -> String? {
    guard
        let color = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSColor.self, from: data),
        let rgb = color.usingColorSpace(.deviceRGB)
    else { return nil }

    func byte(_ component: CGFloat) -> Int {
        Int((min(max(component, 0), 1) * 255).rounded())
    }
    return String(format: "#%02X%02X%02X", byte(rgb.redComponent), byte(rgb.greenComponent), byte(rgb.blueComponent))
}

private func render(_ value: Any, indent: Int = 0) throws -> String {
    if let value = value as? String { return try nixString(value) }
    if let value = value as? NSNumber {
        if isBoolean(value) { return value.boolValue ? "true" : "false" }
        return value.stringValue
    }
    if let value = value as? [Any] {
        if value.isEmpty { return "[ ]" }
        let prefix = String(repeating: " ", count: indent + 2)
        let items = try value.map { prefix + (try render($0, indent: indent + 2)) }
        return "[\n" + items.joined(separator: "\n") + "\n" + String(repeating: " ", count: indent) + "]"
    }
    if let value = value as? [String: Any] {
        if value.isEmpty { return "{ }" }
        let prefix = String(repeating: " ", count: indent + 2)
        let items = try value.keys.sorted().map { key in
            "\(prefix)\(try nixString(key)) = \(try render(value[key]!, indent: indent + 2));"
        }
        return "{\n" + items.joined(separator: "\n") + "\n" + String(repeating: " ", count: indent) + "}"
    }
    throw GeneratorError.message("Unsupported plist value type")
}

private func sanitizedValue(name: String, setting: [String: Any], value: Any) throws -> Any {
    if setting["encoding"] as? String == "nsColor" {
        guard let data = value as? Data, let hex = colorHex(from: data) else {
            throw GeneratorError.message("Could not decode \(name) as an NSColor")
        }
        return hex
    }
    if name == "ToolbarConfiguration" || name == "ToolbarConfigurationForCompactTabs" {
        guard let dictionary = value as? [String: Any] else {
            throw GeneratorError.message("Expected \(name) to be an attribute set")
        }
        return dictionary.filter { toolbarFields.contains($0.key) }
    }
    return value
}

private func generate(options: Options) throws -> (text: String, skipped: Int, warnings: [String]) {
    let catalog = try readDictionary(at: options.catalogPath!, json: true)
    let current = try preferences(options: options)
    var selected: [String: Any] = [:]
    var warnings: [String] = []

    for name in catalog.keys.sorted() where !excludedSettings.contains(name) {
        guard
            let setting = catalog[name] as? [String: Any],
            let rawValue = current[name]
        else { continue }

        do {
            let value = try sanitizedValue(name: name, setting: setting, value: rawValue)
            try validate(name: name, setting: setting, value: value)
            if !options.includeDefaults,
               let defaultValue = setting["default"],
               !(defaultValue is NSNull),
               equivalent(value, defaultValue) {
                continue
            }
            _ = try render(value)
            selected[name] = value
        } catch {
            warnings.append("Skipped \(name): \(error)")
        }
    }

    var lines = [
        "{",
        "  programs.orion = {",
        "    enable = true;",
        "    omittedSettings = \"reset\";",
        "    settings = {",
    ]
    for name in selected.keys.sorted() {
        lines.append("      \(try nixString(name)) = \(try render(selected[name]!, indent: 6));")
    }
    lines += ["    };", "  };", "}", ""]
    let skipped = current.keys.filter { catalog[$0] == nil }.count
    return (lines.joined(separator: "\n"), skipped, warnings)
}

private func write(_ text: String, options: Options) throws {
    guard let path = options.outputPath else {
        print(text, terminator: "")
        return
    }
    let url = URL(fileURLWithPath: path)
    if FileManager.default.fileExists(atPath: path) && !options.force {
        throw GeneratorError.message("Output exists: \(path) (use --force to replace it)")
    }
    try Data(text.utf8).write(to: url, options: .atomic)
}

do {
    let options = try parseOptions()
    let result = try generate(options: options)
    try write(result.text, options: options)
    for warning in result.warnings { fputs("warning: \(warning)\n", stderr) }
    if result.skipped > 0 {
        fputs("note: skipped \(result.skipped) uncataloged preference keys\n", stderr)
    }
} catch {
    fputs("error: \(error)\n", stderr)
    fputs("\(usage())\n", stderr)
    exit(1)
}
