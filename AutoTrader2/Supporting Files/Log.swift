import Foundation

// Log errors to Firebase

class Log {
    static var line: String { return String((0...50).map { _ in return "-" }) }
    static func debug(_ message: String) { print("🤖" + message + "\n") }
    static func info(_ message: String) { print("🎾" + message + "\n") }
    static func error(_ message: String) { print("🔴 ERROR" + line + "\n" + message + line + "\n") }
}
