//
//  WWDCHelper.swift
//  WWDCHelperKit
//
//  Created by kingcos on 06/09/2017.
//
//

import Foundation
import PathKit

public enum WWDCYear: Int {
    case wwdc2016 = 2016
    case wwdc2017 = 2017
    case unknown
    
    init(_ value: Int?) {
        guard let value = value else {
            self = .wwdc2017
            return
        }
        
        switch value {
        case 16, 2016:
            self = .wwdc2016
        case 17, 2017:
            self = .wwdc2017
        default:
            self = .unknown
        }
    }
}

public enum SubtitleLanguage: String {
    case english = "eng"
    case chinese = "zho"
    case unknown
    
    init(_ value: String?) {
        guard let value = value else {
            self = .chinese
            return
        }
        
        switch value {
        case "eng", "English":
            self = .english
        case "chn", "Chinese":
            self = .chinese
        default:
            self = .unknown
        }
    }
}

public enum HelperError: Error {
    case unknownYear
    case unknownSubtitleLanguage
    case unknown
}

public struct WWDCHelper {
    public let year: WWDCYear
    public let sessionIDs: [String]
    
    public let subtitleLanguage: SubtitleLanguage
    public let subtitleFilename: String?
    public let subtitlePath: Path?
    public let isSubtitleForSDVideo: Bool
    public let isSubtitleForHDVideo: Bool
    
    let isSubtitleFilenameCustom: Bool
    
    let parser = SessionContentParser()
    
    public init(year: Int?,
                sessionIDs: [String]?,
                subtitleLanguage: String?,
                subtitleFilename: String?,
                subtitlePath: String?,
                isSubtitleForSDVideo: Bool,
                isSubtitleForHDVideo: Bool) {
        self.year = WWDCYear(year)
        self.sessionIDs = sessionIDs ?? []
        self.subtitleLanguage = SubtitleLanguage(subtitleLanguage)
        self.subtitleFilename = subtitleFilename
        self.subtitlePath = Path(subtitlePath ?? ".").absolute()
        
        if self.subtitleFilename != nil {
            isSubtitleFilenameCustom = true
            
            self.isSubtitleForSDVideo = false
            self.isSubtitleForHDVideo = false
        } else {
            isSubtitleFilenameCustom = false
            
            self.isSubtitleForSDVideo = isSubtitleForSDVideo
            self.isSubtitleForHDVideo = isSubtitleForHDVideo
        }
    }
}

extension WWDCHelper {
    public func initAllSessions() throws -> [WWDCSession] {
        guard year != .unknown else { throw HelperError.unknownYear }
        guard subtitleLanguage != .unknown else { throw HelperError.unknownSubtitleLanguage }
        
        var sessions = [WWDCSession]()
        for key in getSessionsInfo().keys {
            guard let session = initSession(by: key) else { continue }
            sessions.append(session)
        }
        return sessions
    }
    
    func initSession(by id: String) -> WWDCSession? {
        guard let title = getSessionsInfo()[id] else { return nil }
        
        let resources = getResourceURLs(by: id)
        let prefix = getSubtitleIndexURLPrefix(with: resources)
        
        return WWDCSession(id, title, resources, prefix)
    }
}

extension WWDCHelper {
    func getSessionsInfo() -> [String : String] {
        let url = "https://developer.apple.com/videos/wwdc\(year.rawValue)/"
        let content = Network.shared.fetchContent(of: url)
        return parser.parseSessionsInfo(in: content)
    }
    
    func getResourceURLs(by id: String) -> [String] {
        let url = "https://developer.apple.com/videos/play/wwdc\(year.rawValue)/\(id)/"
        let content = Network.shared.fetchContent(of: url)
        return parser.parseResourceURLs(in: content)
    }
    
    func getSubtitleIndexURLPrefix(with resources: [String]) -> String {
        return parser.parseSubtitleIndexURLPrefix(in: resources[0])
    }
}
