enum LogLevel: Int {
    case verbose
    case warning
    case error
}

class SoulfullyLogger {
    static var logWriter: Logable = ConsoleLogger()
    static let logPrefix = "[SoulfullyNetworking]"
    static let logWriterLevel: LogLevel = .verbose
    static func write(log: String, logLevel: LogLevel = .verbose) {
        if logWriterLevel.rawValue <= logLevel.rawValue {
            logWriter.write(log: log)
        }
    }
}

protocol Logable {
    func write(log: String)
}

/// Please use this class in case you need to write debug log into console
class ConsoleLogger: Logable {
    /// Write to the console
    /// - Parameter log: the string that will be write to screen
    func write(log: String) {
        print("\(SoulfullyLogger.logPrefix)\(log)")
    }
}

/// Please use this logger incase you need disable all the log from our system
class NullLogger: Logable {
    /// Write nothing
    /// - Parameter log: this param is not used.
    func write(log: String) {
    }
}
