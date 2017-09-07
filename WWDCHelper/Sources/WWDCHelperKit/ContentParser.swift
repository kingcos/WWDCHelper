//
//  ContentParser.swift
//  WWDCHelperKit
//
//  Created by kingcos on 07/09/2017.
//
//

import Foundation

enum SessionInfoType {
    case subtitleIndexURLPrefix
    case resources
    case sessionsInfo
}

protocol SessionInfoParsable {
    func parseSubtitleIndexURLPrefix(in content: String) -> String
    func parseResources(in content: String) -> [String]
    func parseSessionsInfo(in content: String) -> [String : String]
}

protocol RegexSessionInfoParsable: SessionInfoParsable {
    var patterns: [SessionInfoType : String] { get }
}

extension RegexSessionInfoParsable {
    func parseSubtitleIndexURLPrefix(in content: String) -> String {
        let regex = try! NSRegularExpression(pattern: patterns[.subtitleIndexURLPrefix]!)
        let range = content.wholeNSRange
        let matches = regex.matches(in: content, range: range)
        
        var result = ""
        for match in matches {
            let firstRange = match.rangeAt(1)
            result = content.substring(with: firstRange)
        }
        
        return result
    }
    
    func parseResources(in content: String) -> [String] {
        let regex = try! NSRegularExpression(pattern: patterns[.resources]!)
        let range = content.wholeNSRange
        let matches = regex.matches(in: content, range: range)
        
        var result = [String]()
        for match in matches {
            let firstRange = match.rangeAt(1)
            result.append(content.substring(with: firstRange))
        }
        
        return result
    }
    
    func parseSessionsInfo(in content: String) -> [String : String] {
        let regex = try! NSRegularExpression(pattern: patterns[.sessionsInfo]!)
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

struct SessionParser: RegexSessionInfoParsable {
    let patterns: [SessionInfoType : String] = [
        .subtitleIndexURLPrefix: "(http.*)\\/.*_hd",
        .resources: "<ul class=\"links small\">[\\s\\S]*<a href=\"(https.*dl=1)\">[\\s\\S]*<a href=\"(https.*dl=1)\">[\\s\\S]*<a href=\"(https.*pdf)\">",
        .sessionsInfo: "<a href=\"\\/videos\\/play\\/wwdc[0-9]{4}\\/([0-9]*)\\/\".*\\n.*<h4.*>(.*)</h4>"
    ]
}
