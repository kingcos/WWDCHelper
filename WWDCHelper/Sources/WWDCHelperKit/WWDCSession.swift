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

public struct WWDCSession: Equatable {
    public let id: String
    public let title: String
    public let subtitleIndexURL: String
    public var resources: [WWDCSessionResourceType : String?]
    
    init(_ id: String,
         _ title: String,
         _ resources: [String],
         _ subtitleIndexURL: String) {
        self.id = id
        self.title = title
        self.resources = [WWDCSessionResourceType : String?]()
        self.resources[.hdVideo] = resources[0]
        self.resources[.sdVideo] = resources[1]
        self.resources[.pdf] = resources[2]
        self.subtitleIndexURL = subtitleIndexURL
    }
}


public func ==(lhs: WWDCSession, rhs: WWDCSession) -> Bool {
    let sdVideoFlag = lhs.resources[.sdVideo] ?? "" != rhs.resources[.sdVideo] ?? ""
    let hdVideoFlag = lhs.resources[.hdVideo] ?? "" != rhs.resources[.hdVideo] ?? ""
    let pdfFlag = lhs.resources[.pdf] ?? "" != rhs.resources[.pdf] ?? ""
    
    if lhs.id != rhs.id
        || lhs.title != rhs.title
        || sdVideoFlag
        || hdVideoFlag
        || pdfFlag
        || lhs.subtitleIndexURL != rhs.subtitleIndexURL {
        return false
    }
    
    return true
}

