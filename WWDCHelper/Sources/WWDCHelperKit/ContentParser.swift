//
//  ContentParser.swift
//  WWDCHelperKit
//
//  Created by kingcos on 07/09/2017.
//
//

import Foundation

protocol ContentParsable {
    func parse(in content: String) -> [String: String]
}


