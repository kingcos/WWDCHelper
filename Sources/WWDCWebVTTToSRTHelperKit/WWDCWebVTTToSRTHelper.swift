//
//  WWDCWebVTTToSRTHelper.swift
//  WWDCWevVTTToSRTHelperKit
//
//  Created by kingcos on 09/09/2017.
//
//

import Foundation

public struct WWDCWebVTTToSRTHelper {
    
    let parser = WWDCWebVTTParser()
    
    public init() {
    }
    
    public func parse(_ strArr: [String]) -> String? {
        return parser.parseToSRT(strArr)
    }
}
