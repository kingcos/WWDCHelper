//
//  WWDC2017Parser.swift
//  WWDCHelper
//
//  Created by kingcos on 2018/8/22.
//

import Foundation

public class WWDC2017Parser: RegexSessionInfoParsable {
    let patterns: [SessionInfoType : String] = [
        .subtitleIndexURLPrefix: "(http.*)\\/.*_hd",
        .resources: "<ul class=\"links small\">[\\s\\S]*<a href=\"(https.*dl=1)\">[\\s\\S]*<a href=\"(https.*dl=1)\">[\\s\\S]*<a href=\"(https.*pdf)\">",
        .sessionsInfo: "<a href=\"\\/videos\\/play\\/[\\S]{8}\\/([0-9]*)\\/\".*\\n.*<h4.*>(.*)</h4>"
    ]
}
