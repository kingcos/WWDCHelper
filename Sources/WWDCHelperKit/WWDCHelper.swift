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
import WWDCWebVTTToSRTHelperKit

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
    case eng = "eng"
    case chs = "zho"
    case empty
    case unknown
    
    init(_ value: String?) {
        guard let value = value else {
            self = .empty
            return
        }
        
        switch value {
        case "eng":
            self = .eng
        case "chs":
            self = .chs
        default:
            self = .unknown
        }
    }
}

public enum HelperError: Error {
    case unknownYear
    case unknownSubtitleLanguage
    case unknownSessionID
    case subtitlePathNotExist
}

public struct WWDCHelper {
    public let year: WWDCYear
    public let sessionIDs: [String]?
    
    public let subtitleLanguage: SubtitleLanguage
    public let subtitlePath: Path
    public let isSubtitleForSDVideo: Bool
    
    let parser = WWDC2017Parser()
    let srtHelper = WWDCWebVTTToSRTHelper()
    var sessionsInfo = [String : String]()
    
    public init(year: Int? = nil,
                sessionIDs: [String]? = nil,
                subtitleLanguage: String? = nil,
                subtitlePath: String? = nil,
                isSubtitleForSDVideo: Bool = false) {
        self.year = WWDCYear(year)
        self.sessionIDs = sessionIDs
        self.subtitleLanguage = SubtitleLanguage(subtitleLanguage)
        self.subtitlePath = Path(subtitlePath ?? ".").absolute()
        self.isSubtitleForSDVideo = isSubtitleForSDVideo
    }
}

extension WWDCHelper {
    public mutating func enterHelper() throws {
        guard year != .unknown else { throw HelperError.unknownYear }
        guard subtitleLanguage != .unknown else { throw HelperError.unknownSubtitleLanguage }
        
        let sessions = try getSessions(by: sessionIDs).sorted { $0.0.id < $0.1.id }
        _ = sessions.map { $0.output(year) }
        if subtitleLanguage != .empty {
            if !subtitlePath.exists {
                throw HelperError.subtitlePathNotExist
            } else {
                print("Please wait a little while. Start downloading...")
                try downloadData(sessions)
            }
        }
    }
    
    func downloadData(_ sessions: [WWDCSession]) throws {
        for session in sessions {
            guard let urls = getWebVTTURLs(with: getResourceURLs(by: session.id))
                else { continue }
            
            let strArr = urls
                .map { Network.shared.fetchContent(of: $0).components(separatedBy: "\n") }
                .flatMap { $0.map { $0 } }
            
            guard let result = srtHelper.parse(strArr),
                let data = result.data(using: .utf8) else { return }
            
            var filename = "\(session.id)"
            if isSubtitleForSDVideo {
                filename += "_sd_"
            } else {
                filename += "_hd_"
            }
            
            filename += session.title.lowercased()
                .replacingOccurrences(of: " ", with: "_")
                .replacingOccurrences(of: "/", with: "")
            filename = filename + "." + (subtitleLanguage == .chs ? "chs" : "eng") + ".srt"
            
            let path = subtitlePath + filename
            
            guard !FileManager.default.fileExists(atPath: path.string) else {
                print("\(filename) already exists, skip to download.")
                continue
            }
            
            print(filename, "is downloading...")
            
            try data.write(to: path.url)
        }
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
    
    func getSubtitleIndexURLPrefix(with resources: [String]) -> String? {
        if resources.isEmpty {
            return nil
        }
        return parser.parseSubtitleIndexURLPrefix(in: resources[0])
    }
    
    func getSubtitleIndexURL(with resources: [String]) -> String? {
        guard let prefix = getSubtitleIndexURLPrefix(with: resources) else { return nil }
        return prefix + "/subtitles/eng/prog_index.m3u8"
    }
    
    func getWebVTTURLs(with resources: [String]) -> [String]? {
        guard let urlPrefix = getSubtitleIndexURLPrefix(with: resources),
            let url = getSubtitleIndexURL(with: resources) else { return nil }
        let content = Network.shared.fetchContent(of: url)
        let filesCount = content
            .components(separatedBy: "\n")
            .filter { $0.hasPrefix("fileSequence") }
            .count
        
        var result = [String]()
        for i in 0 ..< filesCount {
            result.append(urlPrefix + "/subtitles/\(subtitleLanguage.rawValue)/fileSequence\(i).webvtt")
        }
        return result
    }
}
