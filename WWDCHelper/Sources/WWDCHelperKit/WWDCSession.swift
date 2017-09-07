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
    public let id: Int
    public let title: String
    public let resources: [WWDCSessionResourceType : String]
    public let subtitleIndexURL: String
}
