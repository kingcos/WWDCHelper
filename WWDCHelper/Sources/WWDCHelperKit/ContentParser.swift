//
//  ContentParser.swift
//  WWDCHelperKit
//
//  Created by kingcos on 07/09/2017.
//
//

import Foundation

protocol ContentParsable {
    func parse(in content: String) -> [String : String]
}

protocol RegexContentParsable: ContentParsable {
    var pattern: String { get }
}

extension RegexContentParsable {
    func parse(in content: String) -> [String : String] {
        let regex = try! NSRegularExpression(pattern: pattern)
        let range = content.wholeNSRange
        let matches = regex.matches(in: content, range: range)
        
        var result = [String : String]()
        for match in matches {
            let firstRange = match.rangeAt(1)
            let secondRange = match.rangeAt(2)
            result[content.substring(with: firstRange)] = content.substring(with: secondRange)
        }
        
        return result
    }
}

struct SessionParser: RegexContentParsable {
    var pattern = "<a href=\"\\/videos\\/play\\/wwdc[0-9]{4}\\/([0-9]*)\\/\".*\\n.*<h4.*>(.*)</h4>"
}
