//
//  Extensions.swift
//  WWDCHelperKit
//
//  Created by kingcos on 07/09/2017.
//
//

import Foundation

extension String {
    var wholeNSRange: NSRange {
        return NSRange(location: 0, length: characters.count)
    }
    
    func substring(with range: NSRange) -> String {
        let nsRange = NSRange(location: range.location, length: range.length)
        return substring(with: nsRange)
    }
}
