import Foundation
import os.log

extension OSLog {
    private static var subsystem = "kz.aitupay.mapper"

    static let network = OSLog(subsystem: subsystem, category: "Network")
    static let ui = OSLog(subsystem: subsystem, category: "UI")
    static let basic = OSLog(subsystem: subsystem, category: "Basic")
    static let webview = OSLog(subsystem: subsystem, category: "Webview")
    static let crypto = OSLog(subsystem: subsystem, category: "Crypto")
}

final class Logger {
    /// Log objects that is passed to logging functions in order to send messages to the logging system.
    enum Category: String {
        case basic = "⚪️"
        case network = "🔵"
        case ui = "🔶"
        case webview = "🌐"
        case crypto = "🈯️"

        var log: OSLog {
            switch self {
            case .network:
                return .network
            case .ui:
                return .ui
            case .basic:
                return .basic
            case .webview:
                return .webview
            case .crypto:
                return .crypto
            }
        }
    }

    /// Logging levels supported by the system.
    ///
    /// - info: Use this log level to capture any information. Stored in memory.
    /// - error: Use this log level to capture information to report errors. Stored in disk.
    enum Level {
        case info
        case error

        var type: OSLogType {
            switch self {
                case .info:
                    return .info
                case .error:
                    return .error
            }
        }
    }

    /// Sends a message to the logging system, optionally specifying a log object, log level, and any message format arguments.
    ///
    /// - Parameters:
    ///   - message: A constant string or format string that produces a human-readable log message.
    ///   - type: A custom log object from categories: General, Network and UI. If unspecified, the basic log level is used.
    ///   - level: The log level. If unspecified, the default log level is used.
    ///   - file: File name where method is called from.
    ///   - function: Function name where method is called from.
    ///   - line: Line number where method is called from.
    static func log(_ message: String,
                    type: Category = .basic,
                    level: Level = .info,
                    _ file: StaticString = #file,
                    _ function: StaticString = #function,
                    _ line: Int = #line) {
        #if DEBUG
            let destination = "\(URL(string: "\(file)")?.lastPathComponent ?? ""):\(line) \(function)"
            let result = "\(type.rawValue) [\(destination)] > \n\(message)"
            os_log("%@", log: type.log, type: level.type, result)
        #endif
    }
}
