//
//  WebVTTParsable.swift
//  WWDCWevVTTToSRTHelperKit
//
//  Created by kingcos on 09/09/2017.
//
//

import Foundation

enum WebVTTParseType {
    case timeline
    case subtitle
}

protocol WebVTTParsable {
    func parseToSRT(_ strArr: [String]) -> String?
}

protocol RegexWebVTTParsable: WebVTTParsable {
    var patterns: [WebVTTParseType : String] { get }
    
    func removeHeader(_ contentArr: inout [String])
    func removeBlankLines(_ contentArr: inout [String])
    func addLineNumbers(_ contentArr: inout [String])
    func dealWithLines(_ contentArr: inout [String])
    func replaceCharacters(_ contentArr: inout [String])
}

extension RegexWebVTTParsable {
    func parseToSRT(_ strArr: [String]) -> String? {
        var contentArr = strArr.map { $0.components(separatedBy: "\n") }
            .flatMap { $0.map { $0 } }
        removeHeader(&contentArr)
        removeBlankLines(&contentArr)
        addLineNumbers(&contentArr)
        dealWithLines(&contentArr)
        replaceCharacters(&contentArr)
        return contentArr
            .reduce("") { $0 + "\n" + $1 }
    }
    
    func removeHeader(_ contentArr: inout [String]) {
        contentArr = contentArr.map { $0
            .components(separatedBy: "\n")
            .filter { !($0.hasPrefix("WEBVTT") || $0.hasPrefix("X-TIMESTAMP-MAP")) }
            .reduce("") { $0 + $1 }
        }
    }
    
    func removeBlankLines(_ contentArr: inout [String]) {
        contentArr = contentArr.filter { $0 != "" }
    }
    
    func addLineNumbers(_ contentArr: inout [String]) {
        var n = 1
        var i = 0
        while i < contentArr.count {
            if contentArr[i].contains("-->") {
                contentArr.insert("\(n)", at: i)
                contentArr.insert("", at: i)
                n += 1
                i += 2
            }
            i += 1
        }
        contentArr.removeFirst()
    }
    
    func dealWithLines(_ contentArr: inout [String]) {
        var result = [String]()
        for content in contentArr {
            let nsStr = NSString(string: content)
            let range = content.wholeNSRange
            let timelineRegex = try! NSRegularExpression(pattern: patterns[.timeline]!)
            let subtitleRegex = try! NSRegularExpression(pattern: patterns[.subtitle]!)
            let timelineMatches = timelineRegex.matches(in: content, range: range)
            let subtitleMatches = subtitleRegex.matches(in: content, range: range)
            
            if !timelineMatches.isEmpty {
                for match in timelineMatches {
                    let firstRange = match.range(at: 1)
                    result.append(nsStr.substring(with: firstRange).replacingOccurrences(of: ".", with: ","))
                }
            } else if !subtitleMatches.isEmpty {
                for match in subtitleMatches {
                    let firstRange = match.range(at: 1)
                    result.append(nsStr.substring(with: firstRange))
                }
            } else {
                result.append(content)
            }
        }
        
        contentArr = result
    }
    
    func replaceCharacters(_ contentArr: inout [String]) {
        contentArr = contentArr.map {
            $0.replacingOccurrences(of: "&gt;", with: ">")
            .replacingOccurrences(of: "&lt;", with: "<")
            .replacingOccurrences(of: "&amp;", with: "&")
        }
    }
}

public struct WWDCWebVTTParser: RegexWebVTTParsable {
    var patterns: [WebVTTParseType : String] = [
        .timeline: "(.*-->.*[0-9]{3})",
        .subtitle: "<.*>(.*)</.*>"
    ]
}
