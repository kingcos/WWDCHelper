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
            self = .wwdc2017
        }
    }
}

public enum SubtitleLanguage: String {
    case english = "eng"
    case chinese = "zho"
    
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
            self = .chinese
        }
    }
}

public struct WWDCHelper {
    public let year: WWDCYear
    public let sessionIDs: [String]
    public let language: SubtitleLanguage
    public let subtitleFilename: String?
    public let isSubtitleForSDVideo: Bool
    public let isSubtitleForHDVideo: Bool
    public let subtitlePath: Path?
    
    let isSubtitleFilenameCustom: Bool
    
    public init(year: Int?,
                sessionIDs: [String]?,
                language: String?,
                subtitleFilename: String?,
                isSubtitleForSDVideo: Bool,
                isSubtitleForHDVideo: Bool,
                subtitlePath: String?) {
        self.year = WWDCYear(year)
        self.sessionIDs = sessionIDs ?? []
        self.language = SubtitleLanguage(language)
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
}
