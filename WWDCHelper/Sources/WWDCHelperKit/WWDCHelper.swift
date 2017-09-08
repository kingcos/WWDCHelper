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
    
    let parser = SessionContentParser()
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
            let sessions = try getSessions(by: sessionIDs)
            _ = sessions.map { printSession($0) }
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
    
    func getSubtitleIndexURL(with resources: [String]) -> String {
        return parser.parseSubtitleIndexURLPrefix(in: resources[0]) + "/subtitles/eng/prog_index.m3u8"
    }
}

extension WWDCHelper {
    func printSession(_ session: WWDCSession) {
        print("\(session.id) - \(session.title)".bold)
        if let hdVideo = session.resources[.hdVideo], hdVideo != "" {
            print("\(WWDCSessionResourceType.hdVideo.rawValue) Download:", "\n\(hdVideo)".underline)
        }
        
        if let sdVideo = session.resources[.sdVideo], sdVideo != "" {
            print("\(WWDCSessionResourceType.sdVideo.rawValue) Download:", "\n\(sdVideo)".underline)
        }
        
        if let pdf = session.resources[.pdf], pdf != "" {
            print("\(WWDCSessionResourceType.pdf.rawValue) Download:", "\n\(pdf)".underline)
        }
        print("- - - - - - - - - -".red)
    }
}
