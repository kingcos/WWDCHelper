//
//  WebVTTParsable.swift
//  WWDCWevVTTToSRTHelperKit
//
//  Created by kingcos on 09/09/2017.
//
//

import Foundation

protocol WebVTTParsable {
    func parseToSRT(_ data: [Data]) -> [Data]
}

protocol RegexWebVTTParsable: WebVTTParsable {
    var patterns: [String] { get }
    
    func removeHeader(_ contentArr: inout [String])
    func removeBlankLines(_ contentArr: inout [String])
    func addLineNumbers(_ contentArr: inout [String])
    func dealWithTimelines(_ contentArr: inout [String])
    //func replaceCharacters()
}

extension RegexWebVTTParsable {
    func parseToSRT(_ data: [Data]) -> [Data] {
        var contentArr = data.map { (String(data: $0, encoding: .utf8) ?? "") }
        removeHeader(&contentArr)
        removeBlankLines(&contentArr)
        addLineNumbers(&contentArr)
        return [Data]()
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
                n += 1
                i += 1
            }
            i += 1
        }
    }
    
    func dealWithTimelines(_ contentArr: inout [String]) {
        
    }
}

public struct WWDCWebVTTParser: RegexWebVTTParsable {
    var patterns = [String]()
}
