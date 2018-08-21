//
//  main.swift
//  WWDCHelper
//
//  Created by kingcos on 07/09/2017.
//
//

import Foundation
import CommandLineKit
import Rainbow
import WWDCHelperKit

let appVersion = "v0.3.0"
let cli = CommandLineKit.CommandLine()

cli.formatOutput = { s, type in
    var str: String
    switch(type) {
    case .error:
        str = s.red.bold
    case .optionFlag:
        str = s.green.underline
    case .optionHelp:
        str = s.blue
    default:
        str = s
    }
    
    return cli.defaultFormat(s: str, type: type)
}

let yearOption = StringOption(shortFlag: "y", longFlag: "year",
                              helpMessage: "Setup the year of WWDC. Support `WWDC2017` & `Fall2017` now. Default is WWDC 2017.")
let sessionIDsOption = MultiStringOption(shortFlag: "s", longFlag: "sessions",
                                         helpMessage: "Setup session numbers in WWDC. Default is all.")
let subtitleLanguageOption = StringOption(shortFlag: "l", longFlag: "language",
                                          helpMessage: "Setup language of subtitle. Only support `chs` or `eng` now. Default is Simplified Chinese.")
let isSubtitleForSDVideoOption = BoolOption(longFlag: "sd",
                                            helpMessage: "Add sd tag for subtitle filename. Default is for hd.")
let subtitlePathOption = StringOption(shortFlag: "p", longFlag: "path",
                                      helpMessage: "Setup download path of subtitles. Default is current folder.")
let helpOption = BoolOption(shortFlag: "h", longFlag: "help",
                            helpMessage: "Print the help info.")
let versionOption = BoolOption(shortFlag: "v", longFlag: "version",
                               helpMessage: "Print the version info.")

cli.addOptions(yearOption,
               sessionIDsOption,
               subtitleLanguageOption,
               isSubtitleForSDVideoOption,
               subtitlePathOption,
               helpOption,
               versionOption)

do {
    try cli.parse()
} catch {
    cli.printUsage(error)
    exit(EX_USAGE)
}

if helpOption.value {
    cli.printUsage()
    exit(EX_OK)
}

if versionOption.value {
    print(appVersion)
    exit(EX_OK);
}

let year = yearOption.value
let sessionIDs = sessionIDsOption.value
let subtitleLanguage = subtitleLanguageOption.value?.lowercased()
let subtitlePath = subtitlePathOption.value
let isSubtitleForSDVideo = isSubtitleForSDVideoOption.value

var helper = WWDCHelper(year: year,
                        sessionIDs: sessionIDs,
                        subtitleLanguage: subtitleLanguage,
                        subtitlePath: subtitlePath,
                        isSubtitleForSDVideo: isSubtitleForSDVideo)

do {
    print("Welcome to WWDCHelper by github.com/kingcos! 👏")
    print("Please wait a little while.\nHelper is trying to fetch your favorite WWDC info hard...")
    try helper.enterHelper()
} catch {
    print("If you have any issues, please contact with me at github.com/kingcos.")
    guard let err = error as? HelperError else {
        print("Unknown Error: \(error)".red.bold)
        exit(EX_USAGE)
    }
    
    switch err {
    case .unknownYear:
        print("WWDC \(year!) isn't been supported currently. Only support WWDC 2017 & Fall 2017 now.".red.bold)
    case .unknownSubtitleLanguage:
        print("Language \(subtitleLanguage!) Only support Simpliefied Chinese or English now.".red.bold)
    case .unknownSessionID:
        print("Session ID was not found".red.bold)
    case .subtitlePathNotExist:
        print("Subtitle path does not exist.")
    }
    
    exit(EX_USAGE)
}


