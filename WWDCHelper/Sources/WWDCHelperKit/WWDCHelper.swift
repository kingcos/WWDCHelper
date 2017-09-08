//
//  WWDCHelper.swift
//  WWDCHelperKit
//
//  Created by kingcos on 06/09/2017.
//
//

import Foundation
import PathKit
import Rainbow

public enum WWDCYear: Int {
    case wwdc2017 = 2017
    case unknown
    
    init(_ value: Int?) {
        guard let value = value else {
            self = .wwdc2017
            return
        }
        
        switch value {
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
    case empty
    case unknown
    
    init(_ value: String?) {
        guard let value = value else {
            self = .empty
            return
        }
        
        switch value {
        case "eng", "english":
            self = .english
        case "chn", "chinese":
            self = .chinese
        default:
            self = .unknown
        }
    }
}

public enum HelperError: Error {
    case unknownYear
    case unknownSubtitleLanguage
    case unknownSessionID
}

public struct WWDCHelper {
    public let year: WWDCYear
    public let sessionIDs: [String]?
    
    public let subtitleLanguage: SubtitleLanguage
    public let subtitleFilename: String?
    public let subtitlePath: Path?
    public let isSubtitleForSDVideo: Bool
    public let isSubtitleForHDVideo: Bool
    
    let isSubtitleFilenameCustom: Bool
    
    let parser = WWDC2017SessionContentParser()
    var sessionsInfo = [String : String]()
    
    public init(year: Int? = nil,
                sessionIDs: [String]? = nil,
                subtitleLanguage: String? = nil,
                subtitleFilename: String? = nil,
                subtitlePath: String? = nil,
                isSubtitleForSDVideo: Bool = false,
                isSubtitleForHDVideo: Bool = false) {
        self.year = WWDCYear(year)
        self.sessionIDs = sessionIDs
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
    public mutating func enterHelper() throws {
        guard year != .unknown else { throw HelperError.unknownYear }
        guard subtitleLanguage != .unknown else { throw HelperError.unknownSubtitleLanguage }
        
        if subtitleLanguage == .empty {
            let sessions = try getSessions(by: sessionIDs).sorted { $0.0.id < $0.1.id }
            _ = sessions.map { $0.output(year) }
        } else {
            
        }
    }
    
    func downloadData() {
        
    }
}

extension WWDCHelper {
    mutating func getSessions(by ids: [String]? = nil) throws -> [WWDCSession] {
        if sessionsInfo.isEmpty {
            sessionsInfo = getSessionsInfo()
        }
        let sessionIDs = ids ?? sessionsInfo.map { $0.0 }
        
        var sessions = [WWDCSession]()
        for sessionID in sessionIDs {
            guard let session = try getSession(by: sessionID) else { continue }
            sessions.append(session)
        }
        
        return sessions
    }
    
    mutating func getSession(by id: String) throws -> WWDCSession? {
        if sessionsInfo.isEmpty {
            sessionsInfo = getSessionsInfo()
        }
        guard let title = sessionsInfo[id] else { throw HelperError.unknownSessionID }
        let resources = getResourceURLs(by: id)
        let url = getSubtitleIndexURL(with: resources)
        
        return WWDCSession(id, title, resources, url)
    }
    
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
    
    func getSubtitleIndexURL(with resources: [String]) -> String? {
        if resources.isEmpty {
            return nil
        }
        return parser.parseSubtitleIndexURLPrefix(in: resources[0]) + "/subtitles/eng/prog_index.m3u8"
    }
}
