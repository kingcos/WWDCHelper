//
//  WWDCHelperKitSpecs.swift
//  WWDCHelperKitTests
//
//  Created by kingcos on 07/09/2017.
//
//

import Foundation
import XCTest
import Spectre
import PathKit

@testable import WWDCHelperKit

public func testWWDCHelperKit() {
    describe("----- WWDCHelpKit Tests -----") {
        
        let fixturesFolderPath = Path(#file).parent().parent() + "Fixtures"
        
        $0.describe("--- WWDC 2017 Parser ---") {
            
            let parser = WWDC2017Parser()
            
            $0.it("should parse subtitle index URL prefix") {
                let content = "https://devstreaming-cdn.apple.com/videos/wwdc/2017/102xyar2647hak3e/102/102_hd_platforms_state_of_the_union.mp4?dl=1"
                let result = parser.parseSubtitleIndexURLPrefix(in: content)
                let expectResult = "https://devstreaming-cdn.apple.com/videos/wwdc/2017/102xyar2647hak3e/102"
                
                try expect(expectResult) == result
            }
            
            $0.it("should parse resources") {
                let content = "<ul class=\"links small\">\n<li class=\"download\" data-hires-status=\"pending\">\n<ul class=\"options\">\n<li><a href=\"https://devstreaming-cdn.apple.com/videos/wwdc/2017/102xyar2647hak3e/102/102_hd_platforms_state_of_the_union.mp4?dl=1\"> onclick=\"s_objectID=&quot;https://devstreaming-cdn.apple.com/videos/wwdc/2017/102xyar2647hak3e/102/102_hd_platforms_state_o_1&quot;;return this.s_oc?this.s_oc(e):true\">HD Video</a></li>\n<li><a href=\"https://devstreaming-cdn.apple.com/videos/wwdc/2017/102xyar2647hak3e/102/102_sd_platforms_state_of_the_union.mp4?dl=1\"> onclick=\"s_objectID=&quot;https://devstreaming-cdn.apple.com/videos/wwdc/2017/102xyar2647hak3e/102/102_sd_platforms_state_o_1&quot;;return this.s_oc?this.s_oc(e):true\">SD Video</a></li>\n</ul>\n</li>\n\n<li class=\"document\" data-hires-status=\"pending\"><a href=\"https://devstreaming-cdn.apple.com/videos/wwdc/2017/102xyar2647hak3e/102/102_platforms_state_of_the_union.pdf\"> onclick=\"s_objectID=&quot;https://devstreaming-cdn.apple.com/videos/wwdc/2017/102xyar2647hak3e/102/102_platforms_state_of_t_1&quot;;return this.s_oc?this.s_oc(e):true\">Presentation Slides (PDF)</a></li>\n</ul>"
                let result = parser.parseResourceURLs(in: content)
                let expectResult = [
                    "https://devstreaming-cdn.apple.com/videos/wwdc/2017/102xyar2647hak3e/102/102_hd_platforms_state_of_the_union.mp4?dl=1",
                    "https://devstreaming-cdn.apple.com/videos/wwdc/2017/102xyar2647hak3e/102/102_sd_platforms_state_of_the_union.mp4?dl=1",
                    "https://devstreaming-cdn.apple.com/videos/wwdc/2017/102xyar2647hak3e/102/102_platforms_state_of_the_union.pdf"
                ]
                
                try expect(expectResult) == result
            }
            
            $0.it("should parse sessions info") {
                let content = "<a href=\"/videos/play/wwdc2017/230/\" onclick=\"s_objectID=&quot;https://developer.apple.com/videos/play/wwdc2017/230/_2&quot;;return this.s_oc?this.s_oc(e):true\">\n<h4 class=\"no-margin-bottom\">Advanced Animations with UIKit</h4>\n</a>"
                let result = parser.parseSessionsInfo(in: content)
                let expectResult = [
                    "230": "Advanced Animations with UIKit"
                ]
                
                try expect(expectResult) == result
            }
        }
        
        $0.describe("--- Network ---") {
            $0.it("should fetch content") {
                let sampleHTML = "SampleContent.html"
                let url = (fixturesFolderPath + sampleHTML).url
                let result = Network.shared.fetchContent(of: url.absoluteString)
                let expectResult = try! String(contentsOf: url)
                
                try expect(expectResult) == result
            }
        }
        
        $0.describe("--- WWDC Helper ---") {
            var helper = WWDCHelper()
            var resourceURLs = [String]()
            
            $0.it("should get sessions info") {
                let result = helper.getSessionsInfo().keys.count
                let expectResult = 138
                
                try expect(expectResult) == result
            }
            
            $0.it("should get resource URLs") {
                let result = helper.getResourceURLs(by: "102")
                let expectResult = [
                    "https://devstreaming-cdn.apple.com/videos/wwdc/2017/102xyar2647hak3e/102/102_hd_platforms_state_of_the_union.mp4?dl=1",
                    "https://devstreaming-cdn.apple.com/videos/wwdc/2017/102xyar2647hak3e/102/102_sd_platforms_state_of_the_union.mp4?dl=1",
                    "https://devstreaming-cdn.apple.com/videos/wwdc/2017/102xyar2647hak3e/102/102_platforms_state_of_the_union.pdf"
                ]
                
                resourceURLs = result
                
                try expect(expectResult) == result
            }
            
            $0.it("should get subtitle index URL prefix") {
                let result = helper.getSubtitleIndexURLPrefix(with: resourceURLs) ?? ""
                let expectResult = "https://devstreaming-cdn.apple.com/videos/wwdc/2017/102xyar2647hak3e/102"
                
                try expect(expectResult) == result
            }
            
            $0.it("should get subtitle index URL") {
                let result = helper.getSubtitleIndexURL(with: resourceURLs) ?? ""
                let expectResult = "https://devstreaming-cdn.apple.com/videos/wwdc/2017/102xyar2647hak3e/102/subtitles/eng/prog_index.m3u8"
                
                try expect(expectResult) == result
            }
            
            $0.it("should get WebVTT URLs") {
                let result = helper.getWebVTTURLs(with: resourceURLs)?.count ?? 0
                let expectResult = 104
                
                try expect(expectResult) == result
            }
            
            $0.it("should get one session") {
                let result = try! helper.getSession(by: "102")!
                let expectResult = WWDCSession("102",
                                               "Platforms State of the Union",
                                               ["https://devstreaming-cdn.apple.com/videos/wwdc/2017/102xyar2647hak3e/102/102_hd_platforms_state_of_the_union.mp4?dl=1",
                                                "https://devstreaming-cdn.apple.com/videos/wwdc/2017/102xyar2647hak3e/102/102_sd_platforms_state_of_the_union.mp4?dl=1",
                                                "https://devstreaming-cdn.apple.com/videos/wwdc/2017/102xyar2647hak3e/102/102_platforms_state_of_the_union.pdf"],
                                               "https://devstreaming-cdn.apple.com/videos/wwdc/2017/102xyar2647hak3e/102/subtitles/eng/prog_index.m3u8")
                
                try expect(expectResult) == result
            }
            
            $0.it("should get sessions") {
                /*let result = try! helper.getSessions().count
                let expectResult = 138
                
                try expect(expectResult) == result*/
            }
            
            $0.it("should print sessions") {
                let session1 = WWDCSession("102",
                                            "Platforms State of the Union",
                                            ["https://devstreaming-cdn.apple.com/videos/wwdc/2017/102xyar2647hak3e/102/102_hd_platforms_state_of_the_union.mp4?dl=1",
                                            "https://devstreaming-cdn.apple.com/videos/wwdc/2017/102xyar2647hak3e/102/102_sd_platforms_state_of_the_union.mp4?dl=1",
                                            "https://devstreaming-cdn.apple.com/videos/wwdc/2017/102xyar2647hak3e/102/102_platforms_state_of_the_union.pdf"],
                                            "https://devstreaming-cdn.apple.com/videos/wwdc/2017/102xyar2647hak3e/102/subtitles/eng/prog_index.m3u8")
                let session2 = WWDCSession("102",
                                           "Platforms State of the Union",
                                           ["",
                                            "",
                                            "https://devstreaming-cdn.apple.com/videos/wwdc/2017/102xyar2647hak3e/102/102_platforms_state_of_the_union.pdf"],
                                            "https://devstreaming-cdn.apple.com/videos/wwdc/2017/102xyar2647hak3e/102/subtitles/eng/prog_index.m3u8")
                
                _ = [session1, session2].map { $0.output(helper.year) }
            }
            
            $0.it("should enter helper, then print sessions") {
                /*
                var helper = WWDCHelper()
                try! helper.enterHelper()
 
                helper = WWDCHelper(year: 2017)
                try! helper.enterHelper()
 
                helper = WWDCHelper(year: 2017, sessionIDs: ["102", "802"])
                try! helper.enterHelper()
                */
                helper = WWDCHelper(sessionIDs: ["202"])
                try! helper.enterHelper()
            }
            
            $0.it("should enter helper, then print sessions & download subtitle") {
                /*
                helper = WWDCHelper(sessionIDs: ["202"], subtitleLanguage: "chs", subtitlePath: "./resources")
                try! helper.enterHelper()
                */
            }
        }
    }
}

public func ==(lhs: Expectation<WWDCSession>, rhs: WWDCSession) throws {
    if let left = try lhs.expression() {
        if left != rhs {
            throw lhs.failure("\(String(describing: left)) is not equal to \(rhs)")
        }
        
    } else {
        throw lhs.failure("given value is nil")
    }
}

public func ==(lhs: Expectation<[WWDCSession]>, rhs: [WWDCSession]) throws {
    if let left = try lhs.expression() {
        guard left.count == rhs.count else {
            throw lhs.failure("\(String(describing: left)) is not equal to \(rhs)")
        }
        for i in 0 ..< left.count {
            if left[i] != rhs[i] {
                throw lhs.failure("\(String(describing: left)) is not equal to \(rhs)")
            }
        }
    } else {
        throw lhs.failure("given value is nil")
    }
}

