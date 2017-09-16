//
//  WWDCWebVTTToSRTHelperKitSpecs.swift
//  WWDCWebVTTToSRTHelperKitTests
//
//  Created by kingcos on 09/09/2017.
//
//

import Foundation
import XCTest
import Spectre
import PathKit

@testable import WWDCWebVTTToSRTHelperKit

public func testWWDCWebVTTToSRTHelperKit() {
    describe("----- WWDCWebVTTToSRTHelperKit Tests -----") {
        
        let fixturesFolderPath = Path(#file).parent().parent() + "Fixtures"
        
        $0.describe("--- WebVTT Parser ---") {
            
            let parser = WWDCWebVTTParser()
            var contentArr = ["WEBVTT",
                              "X-TIMESTAMP-MAP=MPEGTS:181083,LOCAL:00:00:00.000",
                              "",
                              "01:42:58.766 --> 01:43:00.516 A:middle",
                              "&gt;&gt;  And with that, I hope you have a  &lt;&lt;",
                              "",
                              "WEBVTT",
                              "X-TIMESTAMP-MAP=MPEGTS:181083,LOCAL:00:00:00.000",
                              "",
                              "01:43:00.516 --> 01:43:01.546 A:middle",
                              "<c.magenta>great conference, and I'll see</c>",
                              "<c.magenta>you &amp; them around this week.</c>",
                              ""]
            
            $0.it("should remove header") {
                parser.removeHeader(&contentArr)
                let expectResult = ["",
                                    "",
                                    "",
                                    "01:42:58.766 --> 01:43:00.516 A:middle",
                                    "&gt;&gt;  And with that, I hope you have a  &lt;&lt;",
                                    "",
                                    "",
                                    "",
                                    "",
                                    "01:43:00.516 --> 01:43:01.546 A:middle",
                                    "<c.magenta>great conference, and I'll see</c>",
                                    "<c.magenta>you &amp; them around this week.</c>",
                                    ""]
                
                try expect(expectResult) == contentArr
            }
            
            $0.it("should remove blank lines") {
                parser.removeBlankLines(&contentArr)
                let expectResult = ["01:42:58.766 --> 01:43:00.516 A:middle",
                                    "&gt;&gt;  And with that, I hope you have a  &lt;&lt;",
                                    "01:43:00.516 --> 01:43:01.546 A:middle",
                                    "<c.magenta>great conference, and I'll see</c>",
                                    "<c.magenta>you &amp; them around this week.</c>"]
                
                try expect(expectResult) == contentArr
            }
            
            $0.it("should add line numbers") {
                parser.addLineNumbers(&contentArr)
                let expectResult = ["1",
                                    "01:42:58.766 --> 01:43:00.516 A:middle",
                                    "&gt;&gt;  And with that, I hope you have a  &lt;&lt;",
                                    "",
                                    "2",
                                    "01:43:00.516 --> 01:43:01.546 A:middle",
                                    "<c.magenta>great conference, and I'll see</c>",
                                    "<c.magenta>you &amp; them around this week.</c>"]
                
                try expect(expectResult) == contentArr
            }
            
            $0.it("should deal with lines") {
                parser.dealWithLines(&contentArr)
                let expectResult = ["1",
                                    "01:42:58,766 --> 01:43:00,516",
                                    "&gt;&gt;  And with that, I hope you have a  &lt;&lt;",
                                    "",
                                    "2",
                                    "01:43:00,516 --> 01:43:01,546",
                                    "great conference, and I'll see",
                                    "you &amp; them around this week."]
                
                try expect(expectResult) == contentArr
            }
            
            $0.it("should replace characters") {
                parser.replaceCharacters(&contentArr)
                let expectResult = ["1",
                                    "01:42:58,766 --> 01:43:00,516",
                                    ">>  And with that, I hope you have a  <<",
                                    "",
                                    "2",
                                    "01:43:00,516 --> 01:43:01,546",
                                    "great conference, and I'll see",
                                    "you & them around this week."]
                
                try expect(expectResult) == contentArr
            }
            
            $0.it("should replace characters") {
                parser.replaceCharacters(&contentArr)
                let expectResult = ["1",
                                    "01:42:58,766 --> 01:43:00,516",
                                    ">>  And with that, I hope you have a  <<",
                                    "",
                                    "2",
                                    "01:43:00,516 --> 01:43:01,546",
                                    "great conference, and I'll see",
                                    "you & them around this week."]
                
                try expect(expectResult) == contentArr
            }
            
            $0.it("should parse to SRT") {
                var urls = [URL]()
                for i in 0 ..< 3 {
                    urls.append((fixturesFolderPath + "fileSequence\(i).webvtt").url)
                }
                
                let strArr = urls.map { try! String(contentsOf: $0) }
                
                guard let string = parser.parseToSRT(strArr) else { return }
                let result = string.components(separatedBy: "\n").count
                let expectResult = 328
                
                try expect(expectResult) == result
            }
        }
    }
}
