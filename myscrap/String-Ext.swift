//
//  String-Ext.swift
//  myscrap
//
//  Created by MS1 on 10/1/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//
//, .usesFontLeading
import UIKit
extension String {
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin], attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.height
    }
    
    
    func truncate(length: Int) -> String {
        if count > length {
            return String(prefix(length))
        } else {
            return self
        }
    }
    
    var length: Int {
        return self.count
    }
    
    func initials() -> String {
        
        var arr = self.components(separatedBy: " ")
        
        if arr.count == 0 { return "" }
        
        return  arr[0].firstLetter() + " " + arr[arr.count - 1].firstLetter()
    }
    
    func firstLetter() -> String {
        for c in self {
            return "\(c)"
        }
        return ""
    }
    
    func withoutWhitespace() -> String {
        return self.replacingOccurrences(of: "\n", with: "")
            .replacingOccurrences(of: "\r", with: "")
            .replacingOccurrences(of: "\0", with: "")
    }
    
    func nsRange(from range: Range<Index>) -> NSRange {
        return NSRange(range, in: self)
    }
    
    
    func subStringranges(of substring: String, options: CompareOptions = [], locale: Locale? = nil) -> [Range<Index>] {
        var ranges: [Range<Index>] = []
        while let range = self.range(of: substring, options: options, range: (ranges.last?.upperBound ?? self.startIndex)..<self.endIndex, locale: locale) {
            ranges.append(range)
        }
        return ranges
    }
    
    
    
    func extractedWeblinks()  -> [NSRange]? {
        var ranges : [NSRange] = []
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
            let matches = detector.matches(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count))
            for match in matches{
                guard let range = Range(match.range, in: self) else { continue }
                ranges.append(self.nsRange(from: range))
             }
        } catch let err {
            print(err.localizedDescription)
        }
        return ranges.isEmpty ? nil : ranges
    }
    
    
    func range(from nsRange: NSRange) -> Range<String.Index>? {
        guard
            let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
            let to16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location + nsRange.length, limitedBy: utf16.endIndex),
            let from = from16.samePosition(in: self),
            let to = to16.samePosition(in: self)
            else { return nil }
        return from ..< to
    }
    
    
}


extension NSString {
    
    func initials() -> NSString {
        var arr = self.components(separatedBy: " ")
        if arr.count == 0 { return "" }
        
        return  (arr[0].firstLetter() + arr[arr.count - 1]) as NSString
    }
    
    func firstLetter() -> NSString {
        return self.substring(to: 1) as NSString
    }
    
    
    
    
}
