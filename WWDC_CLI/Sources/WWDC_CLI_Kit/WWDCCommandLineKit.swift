public enum WWDCYear: Int {
    case wwdc2016 = 2016
    case wwdc2017 = 2017
    
    init?(_ value: Int) {
        switch value {
        case 16, 2016:
            self = .wwdc2016
        case 17, 2017:
            self = .wwdc2017
        default:
            return nil
        }
    }
}

public enum SubtitleLanguage: String {
    case english = "eng"
    case chinese = "zho"
    
    init?(_ value: String) {
        switch value {
        case "eng", "English":
            self = .english
        case "chn", "Chinese":
            self = .chinese
        default:
            return nil
        }
    }
}

public struct WWDCCommandLineKit {
    public let year: WWDCYear
    public let isList: Bool
    public let sessionIDs: [Int]
    public let language: SubtitleLanguage
    public let subtitleFilename: String?
    public let isSubtitleForSDVideo: Bool
    public let isSubtitleForHDVideo: Bool
    public let subtitlePath: String?
    
    let isSubtitleFilenameCustom: Bool
    
    public init(year: WWDCYear?,
                isList: Bool,
                sessionIDs: [Int]?,
                language: SubtitleLanguage?,
                subtitleFilename: String?,
                isSubtitleForSDVideo: Bool,
                isSubtitleForHDVideo: Bool,
                subtitlePathOption: String?) {
        self.year = year ?? .wwdc2017
        self.isList = isList
        self.sessionIDs = sessionIDs ?? []
        self.language = language ?? .chinese
        self.subtitleFilename = subtitleFilename
        self.subtitlePath = subtitlePathOption
        
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

extension WWDCCommandLineKit {
    public func getSessionsList() -> [WWDCSession]? {
        return nil
    }
    
    public func getSession() {
        
    }
    
    public func getSubtitles() {
        
    }
}
