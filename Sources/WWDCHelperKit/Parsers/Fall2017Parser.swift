//
//  Fall2017Parser.swift
//  WWDCHelper
//
//  Created by kingcos on 2018/8/22.
//

import Foundation

public class Fall2017Parser: RegexSessionInfoParsable {
    let patterns: [SessionInfoType : String] = [
        .subtitleIndexURLPrefix: "(http.*)\\/.*_hd",
        .resources: "<ul class=\"links small\">[\\s\\S]*<a href=\"(https.*dl=1)\">[\\s\\S]*<a href=\"(https.*dl=1)\">",
        .sessionsInfo: "<a href=\"\\/videos\\/play\\/[\\S]{8}\\/([0-9]*)\\/\".*\\n.*<h4.*>(.*)</h4>"
    ]
    
    func parseResourceURLs(in content: String) -> [String] {
        let nsStr = NSString(string: content)
        let regex = try! NSRegularExpression(pattern: patterns[.resources]!)
        let range = content.wholeNSRange
        let matches = regex.matches(in: content, range: range)
        
        var result = [String]()
        for match in matches {
            let firstRange = match.range(at: 1)
            let secondRange = match.range(at: 2)
            
            result.append(nsStr.substring(with: firstRange))
            result.append(nsStr.substring(with: secondRange))
        }
        
        return result
    }
}
