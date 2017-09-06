//
//  Extensions.swift
//  WWDC_CLI_Kit
//
//  Created by kingcos on 07/09/2017.
//
//

import Foundation

extension String {
    var wholeNSRange: NSRange {
        return NSRange(location: 0, length: characters.count)
    }
    
    func substring(with range: NSRange) {
        let nsRange = NSRange(location: range.location, length: range.length)
        substring(with: nsRange)
    }
}
