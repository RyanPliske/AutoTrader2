import Foundation

// Log errors to Firebase

class Log {
    static var dottedLine: String { return String((0...50).map { _ in return "-" }) }
    static func debug(_ message: String) { print("🤖 " + message + "\n") }
    static func info(_ message: String) { print("🎾 " + message + "\n") }
    static func error(_ message: String, _ file: String = #file, _ function: String = #function, _ line: Int = #line) { print("🔴 ERROR\n" + dottedLine + "\n" + message + " File: \(file)" + " Function: \(function)" + " Line: \(line)" + "\n" + dottedLine + "\n") }
}
