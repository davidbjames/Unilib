//
//  Debug.swift
//  ViewQuery
//
//  Created by David James on 1/20/17.
//  Copyright © 2017 David B James. All rights reserved.
//

import UIKit

// "ApiDebug" is a development-only debug tool that provides
// user-friendly console output intended to "reveal" the operations of
// any API/library that uses it. (RxSwift.debug does something similar.)
// Libraries that use it would add pertinent debug output at critical points 
// in the code and then users of the library would toggle debug output
// via a "debug" operator or similar mechanism (optionally passing DebugConfig 
// and DebugOptions).

/// NOTE: "ApiDebug" is not a general purpose logging/reporting system, which
/// could exist alongside. As such, "ApiDebug" has no reporting levels, etc.

public struct ApiDebugOptions : OptionSet {
    public let rawValue:Int
    public init(rawValue:Int) {
        self.rawValue = rawValue
    }
    /// Abbreviated output.
    public static let compact = ApiDebugOptions(rawValue: 1 << 0)
    /// Extended output. Pretty print plus add'l vertical space for readability.
    public static let expanded = ApiDebugOptions(rawValue: 1 << 1)
    
    public static let autolayout = ApiDebugOptions(rawValue: 1 << 2)
    
    fileprivate var isDefaultVerbosity:Bool {
        return !contains(.expanded) && !contains(.compact)
    }
}

/// Whether debugging is off, on or is on with options.
public enum ApiDebugConfig {
    
    case off
    case on
    case onWithOptions(ApiDebugOptions)
    
    public var isDebug:Bool {
        switch self {
        case .off :
            return false
        case .on, .onWithOptions :
        #if DEBUG
            return true
        #else
            return false
        #endif
        }
    }
    
    public var isAutoLayoutDebug:Bool {
        if case .onWithOptions(let options) = self {
            #if DEBUG
                return options.contains(.autolayout)
            #else
                return false
            #endif
        } else {
            return false
        }
    }
    
    /// Factory to get a debug instance
    public var debug:ApiDebug? {
        switch self {
        case .on :
            return ApiDebug()
        case .onWithOptions(let options) :
            return ApiDebug(options)
        case .off :
            return nil
        }
    }
}

public protocol ApiDebugPrintable : CustomStringConvertible {
    var options:ApiDebugOptions { get }
    var shortOutput:String { get }
    func pretty(indent:Int?) -> String
}

extension ApiDebugPrintable {
    public func output(indent:Int? = nil) {
        // This should be the ONLY print statement related to debugging.
        print(options.contains(.compact) ? shortOutput : pretty(indent:indent))
    }
}

/// Wrapper for outputting structured API debug information to the console.
/// NOT a general logging system.
public struct ApiDebug {
    
    public let options:ApiDebugOptions
    
    public init?(_ options:ApiDebugOptions? = nil) {
        #if DEBUG
            self.options = options ?? []
        #else
            return nil
        #endif
    }
    
    public func notice(_ message:String) -> ApiDebug.Log {
        return Log(options:self.options, message: message, type:.notice)
    }
    
    public func warning(_ message:String) -> ApiDebug.Log {
        return Log(options:self.options, message: message, type:.warning)
    }
    
    public func error(_ message:String) -> ApiDebug.Log {
        return Log(options:self.options, message: message, type:.error)
    }
    
    public func message(_ message:String, icon:String? = nil) -> ApiDebug.Basic {
        return Basic(options:self.options, message: message, icon:icon)
    }
    
    /// Output a result. This is the same as message() but adds a bit of
    /// decoration to the message to indicate it's a final result. Use at 
    /// the end of a series of operations when a final value has been computed.
    public func result(_ message:String) -> ApiDebug.Result {
        return Result(options: self.options, message: message)
    }
    
    /// Output a method signature with runtime values.
    public func method(_ wrapper:Any, _ method:String, _ params:[String]? = nil, _ vals:[Any?]? = nil, delegates:Bool = false) -> ApiDebug.Method {
        return Method(options:self.options, wrapper:wrapper, method:method, params:params, vals:vals, delegates:delegates)
    }
    
    public func constructor(_ wrapper:Any, _ params:[String]? = nil, _ vals:[Any?]? = nil) -> ApiDebug.Method {
        return Method(options:self.options, wrapper:wrapper, method:"init", params:params, vals:vals, delegates: false)
    }

    // Printable debug wrappers
    
    public struct Log : ApiDebugPrintable {
        
        public let options:ApiDebugOptions
        
        var message:String
        let type:LogType
        
        enum LogType : CustomStringConvertible {
            case notice, warning, error
            var description: String {
                switch self {
                case .notice :
                    return "NOTICE"
                case .warning :
                    return "WARNING"
                case .error :
                    return "ERROR"
                }
            }
            var icon:String {
                switch self {
                case .notice :
                    return "💬"
                case .warning :
                    return "⚠️"
                case .error :
                    return "🔥🔥🔥"
                }
            }
        }
        
        public var description: String {
            return "\(type): \(message)"
        }
        
        public var shortOutput: String {
            return "ViewQuery Log:    \(description)"
        }
        
        public func pretty(indent:Int?) -> String {
            var output = repeatElement(" " , count: (indent ?? 0) * 4).joined()
            output += type.icon // 💬 ⚠️ 🔥
            output += " "
            output += description
            if options.contains(.expanded) {
                output += "\n"
            }
            return output
        }
    }
    
    public struct Basic : ApiDebugPrintable {

        public let options:ApiDebugOptions
        
        private var message:String
        private let icon:String
        private var prefix:String?
        private var suffix:String?
        
        init(options:ApiDebugOptions, message:String, icon:String? = nil) {
            self.options = options
            self.message = message
            self.icon = icon ?? "⚙️"
        }
        public var description: String {
            var before = ""
            var after = ""
            if let prefix = prefix {
                before = "\(prefix) "
            }
            if let suffix = suffix {
                after = " \(suffix)"
            }
            return before + message + after
        }
        
        public var shortOutput: String {
            return "ViewQuery Debug:  \(description)"
        }
        
        public func pretty(indent:Int?) -> String {
            var output = repeatElement(" " , count: (indent ?? 0) * 4).joined()
            if let prefix = prefix {
                output += "\(prefix) "
            }
            output += "\(icon) "
            output += message
            if let suffix = suffix {
                output += " \(suffix)"
            }
            if options.contains(.expanded) {
                output += "\n"
            }
            return output
        }
        
        public mutating func prepend(_ string:String) {
            if let prefix = prefix {
                self.prefix = "\(string) " + prefix
            } else {
                self.prefix = string
            }
        }

        public mutating func append(_ string:String) {
            if let suffix = suffix {
                self.suffix = suffix + " \(string)"
            } else {
                self.suffix = string
            }
        }
    }
    
    public struct Result : ApiDebugPrintable {
        
        public var options:ApiDebugOptions
        
        fileprivate var message:String
        
        public var description: String {
            return message
        }
        
        public var shortOutput: String {
            return "ViewQuery Result: \(description)"
        }

        public func pretty(indent:Int?) -> String {
            var output = repeatElement(" " , count: (indent ?? 4) * 4).joined()
            output += "🎁 "
            output += description
            if options.contains(.expanded) {
                output += "\n"
            }
            return output
        }

    }
    
    // TODO: ✅ Consider mapping argument calls to colons in the standard #function macro.
    // This would obviate some brittle debug code (the parameter names) but beware the result
    // would not be exactly the same as it is now. #function uses *external* argument names
    // (which when no external would be _), instead of the current *internal* argument names
    // which frequently are more helpful.
    
    public struct Method : ApiDebugPrintable {
        
        public let options:ApiDebugOptions

        fileprivate let wrapper:Any
        fileprivate let method:String
        
        fileprivate var params:[String]?
        fileprivate var vals:[Any?]?
        
        fileprivate let delegates:Bool
        
        public var description:String {
            
            let isInit = method == "init"
            
            var output = options.contains(.compact) ? "" : (isInit ? "🚛 " : "🚜 ")
            
            output += String(describing:type(of:wrapper))
            if isInit {
                // Don't add the method name because inits don't count.
                // Example: ViewMutator(..)
            } else {
                // remove from first open parens onward
                // this allows passing #function to this.
                output += "." + method.trim(from: "(")
                // Example: ViewMutator.center(..)
            }
            output += "("
            
            if let params = self.params, let values = self.vals {
                
                for i in 0..<(params.count) {
                    
                    guard i >= values.startIndex && i < values.endIndex else {
                        continue
                    }
                    
                    output += params[i] + ":"
                    
                    let _val = values[i] // this returns an optional
                    
                    if let value = _val {
                        
                        if let displayStyle = Mirror(reflecting: value).displayStyle {
                            
                            switch displayStyle {
                            case .class :
                                output += String(describing: type(of:value))
                                if value is NSObject {
                                    // For NSObjects/UIView include the memory address
                                    output += " (" + (value as! NSObject).memoryAddress(shortened: true)  + ")"
                                }
                            default : // .enum, .collection, .struct, .tuple, .dictionary, .set
                                output += String(describing:value)
                            }
                            
                        } else {
                            // All other primitive values, output as is.
                            output += String(describing: value)
                        }
                    } else {
                        output += "nil"
                    }
                    
                    if i < params.count - 1 {
                        output += ", "
                    }
                }
            }
            
            output += ")"
            
            if delegates && !options.contains(.compact) {
                // The method called for this debug delegates to another method with debug information.
                output += " ..."
            }
            
            return output
        }
        
        public var shortOutput: String {
            return "ViewQuery Method: \(description)"
        }

        public func pretty(indent:Int?) -> String  {
            var output = ""
            if indent == nil {
                // extra line for first indent
                output += "\n"
            }
            let indentString = repeatElement(" ", count: (indent ?? 0) * 4).joined()
            output += indentString
            output += repeatElement("▪️", count: 30).joined()
            output += "\n"
            output += indentString
            output += description
            if options.contains(.expanded) {
                output += "\n"
            }
            return output
        }
    }
}
