//
//  WWDCSession.swift
//  WWDCHelperKit
//
//  Created by kingcos on 06/09/2017.
//
//

import Foundation

public enum WWDCSessionResourceType {
    case sdVideo
    case hdVideo
    case pdf
}

public struct WWDCSession {
    public let id: String
    public let title: String
    public let subtitleIndexURL: String
    public var resources: [WWDCSessionResourceType : String?]
    
    init(_ id: String,
         _ title: String,
         _ resources: [String?],
         _ subtitleIndexURLPrefix: String) {
        self.id = id
        self.title = title
        self.resources = [WWDCSessionResourceType : String?]()
        self.resources[.sdVideo] = resources[0]
        self.resources[.hdVideo] = resources[1]
        self.resources[.pdf] = resources[2]
        self.subtitleIndexURL = subtitleIndexURLPrefix + "/subtitles/eng/prog_index.m3u8"
    }
}
