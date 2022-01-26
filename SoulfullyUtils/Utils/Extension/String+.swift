//
//  File.swift
//  ServicePlatform
//
//

import Foundation

// MARK: - Check validate
extension String {
    var isValidEmail: Bool {
        return Validation.emailValidation(email: self)
    }
    
    var isValidPhone: Bool {
        return Validation.phoneNumberValidation(phone: self)
    }
    
    var isValidPassword: Bool {
        return Validation.passwordValidation(password: self)
    }
    
    var isValidUsername: Bool {
        return Validation.usernameValidation(username: self)
    }
}

// swiftlint:disable identifier_name line_length
extension String {
    func range(from nsRange: NSRange) -> Range<String.Index>? {
        guard
            let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
            let to16 = utf16.index(from16, offsetBy: nsRange.length, limitedBy: utf16.endIndex),
            let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self)
        else { return nil }
        return from ..< to
    }
}

public extension String {
    
    // MARK: Subscripts
    subscript(value: PartialRangeUpTo<Int>) -> Substring {
        return self[..<index(startIndex, offsetBy: value.upperBound)]
    }
    
    subscript(value: PartialRangeThrough<Int>) -> Substring {
        return self[...index(startIndex, offsetBy: value.upperBound)]
    }
    
    subscript(value: PartialRangeFrom<Int>) -> Substring {
        return self[index(startIndex, offsetBy: value.lowerBound)...]
    }
    
    func substring(to: Int) -> String {
        return String(self[...min(count - 1, to)])
    }
    
    func substring(from: Int) -> String {
        return String(self[max(0, from)...])
    }
    
    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(count, r.lowerBound)),
                                            upper: min(count, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
    
    // MARK: Extended functions
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    /// Truncates the string to the specified length number of characters and appends an optional trailing string if longer.
    func truncate(length: Int, trailing: String = "") -> String {
        return (self.count > length) ? (String(self.prefix(length)) + trailing) : self
    }
    
    /// Determine whether the given value in string type is Zero or not
    var isZero: Bool {
        if let num = self.components(separatedBy: " ").first, let inFloat = Float(num), inFloat == 0.0 {
            return true
        }
        return false
    }
    
    func encodeURL() -> URL? {
        if let encodedURL = self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            return URL(string: encodedURL)
        }
        return nil
    }
    
    func nsRange(from range: Range<Index>) -> NSRange {
        if let lower = UTF16View.Index(range.lowerBound, within: utf16),
           let upper = UTF16View.Index(range.upperBound, within: utf16) {
            return NSRange(location: utf16.distance(from: utf16.startIndex, to: lower),
                           length: utf16.distance(from: lower, to: upper))
        }
        return NSRange()
    }
    
    var masked: String {
        return String(repeating: "x", count: max(0, count-4)) + String(suffix(4))
    }
}

extension String {
    // MARK: Convert UTC To Local Date by passing date formats value
    func UTCToLocal(incomingFormat: String, outGoingFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = incomingFormat
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let dt = dateFormatter.date(from: self)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = outGoingFormat
        
        return dateFormatter.string(from: dt ?? Date())
    }
        
    func toDateWith(format: String,
                    locale: Locale = Locale(identifier: "vn"),
                    timeZone: TimeZone? = TimeZone.current) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = locale
        dateFormatter.timeZone = timeZone
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)
    }
        
    enum Unit: String {
        case second, min, hour, day, week, month
        var desc: String {
            return rawValue
        }
    }
}
