//
//  HelperKitSpecs.swift
//  WWDCHelperKitTests
//
//  Created by kingcos on 07/09/2017.
//
//

import Foundation
import XCTest
import Spectre

@testable import WWDCHelperKit

public func testWWDCHelperKit() {
    describe("----- WWDCHelpKit Tests -----") {
        $0.describe("--- Session Content Parser ---") {
            
            let parser = SessionContentParser()
            
            $0.it("should parse subtitle index URL prefix") {
                let content = "https://devstreaming-cdn.apple.com/videos/wwdc/2017/102xyar2647hak3e/102/102_hd_platforms_state_of_the_union.mp4?dl=1"
                let result = parser.parseSubtitleIndexURLPrefix(in: content)
                let expectResult = "https://devstreaming-cdn.apple.com/videos/wwdc/2017/102xyar2647hak3e/102"
                
                try expect(expectResult) == result
            }
            
            $0.it("should parse resources") {
                let content = "<ul class=\"links small\">\n<li class=\"download\" data-hires-status=\"pending\">\n<ul class=\"options\">\n<li><a href=\"https://devstreaming-cdn.apple.com/videos/wwdc/2017/102xyar2647hak3e/102/102_hd_platforms_state_of_the_union.mp4?dl=1\"> onclick=\"s_objectID=&quot;https://devstreaming-cdn.apple.com/videos/wwdc/2017/102xyar2647hak3e/102/102_hd_platforms_state_o_1&quot;;return this.s_oc?this.s_oc(e):true\">HD Video</a></li>\n<li><a href=\"https://devstreaming-cdn.apple.com/videos/wwdc/2017/102xyar2647hak3e/102/102_sd_platforms_state_of_the_union.mp4?dl=1\"> onclick=\"s_objectID=&quot;https://devstreaming-cdn.apple.com/videos/wwdc/2017/102xyar2647hak3e/102/102_sd_platforms_state_o_1&quot;;return this.s_oc?this.s_oc(e):true\">SD Video</a></li>\n</ul>\n</li>\n\n<li class=\"document\" data-hires-status=\"pending\"><a href=\"https://devstreaming-cdn.apple.com/videos/wwdc/2017/102xyar2647hak3e/102/102_platforms_state_of_the_union.pdf\"> onclick=\"s_objectID=&quot;https://devstreaming-cdn.apple.com/videos/wwdc/2017/102xyar2647hak3e/102/102_platforms_state_of_t_1&quot;;return this.s_oc?this.s_oc(e):true\">Presentation Slides (PDF)</a></li>\n</ul>"
                let result = parser.parseResources(in: content)
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
        
        $0.describe(" --- Network ---") {
            $0.it("should request content") {
                let expectResult = ""
                let result = Network.shared.requestContent(of: "")
                
                try expect(expectResult) == result
            }
        }
    }
}
