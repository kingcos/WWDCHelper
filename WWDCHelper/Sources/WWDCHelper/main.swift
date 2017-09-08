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

let yearOption = IntOption(shortFlag: "y", longFlag: "year",
                           helpMessage: "Setup the year of WWDC. Only support 2017 now. Default is WWDC 2017.")
let sessionIDsOption = MultiStringOption(shortFlag: "s", longFlag: "sessions",
                                         helpMessage: "Setup session numbers in WWDC.")
let subtitleLanguageOption = StringOption(shortFlag: "l", longFlag: "language",
                                          helpMessage: "Setup the language of subtitle. Only support Chinese or English now. Default is Chinese.")
let subtitleFilenameOption = StringOption(shortFlag: "n", longFlag: "name",
                                          helpMessage: "Setup the filename of subtitle. Default is same to session download name.")
let isSubtitleForSDVideoOption = BoolOption(shortFlag: "", longFlag: "sd",
                                          helpMessage: "Setup default subtitle filename of SD video.")
let isSubtitleForHDVideoOption = BoolOption(shortFlag: "", longFlag: "hd",
                                          helpMessage: "Setup default subtitle filename of HD video.")
let subtitlePathOption = StringOption(shortFlag: "p", longFlag: "path",
                                      helpMessage: "Setup where download the subtitle to. Default is the Download folder.")
let helpOption = BoolOption(shortFlag: "h", longFlag: "help",
                            helpMessage: "Print this help info.")
let versionOption = BoolOption(shortFlag: "v", longFlag: "version",
                               helpMessage: "Print version info.")

cli.addOptions(yearOption,
               sessionIDsOption,
               subtitleLanguageOption,
               subtitleFilenameOption,
               isSubtitleForSDVideoOption,
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

let year = yearOption.value
let sessionIDs = sessionIDsOption.value
let subtitleLanguage = subtitleLanguageOption.value?.lowercased()
let subtitleFilename = subtitleFilenameOption.value
let subtitlePath = subtitlePathOption.value
let isSubtitleForSDVideo = isSubtitleForSDVideoOption.value
let isSubtitleForHDVideo = isSubtitleForHDVideoOption.value

var helper = WWDCHelper(year: year,
                        sessionIDs: sessionIDs,
                        subtitleLanguage: subtitleLanguage,
                        subtitleFilename: subtitleFilename,
                        subtitlePath: subtitlePath,
                        isSubtitleForSDVideo: isSubtitleForSDVideo,
                        isSubtitleForHDVideo: isSubtitleForHDVideo)

do {
    print("Welcome to WWDCHelper by kingcos! 👏")
    print("Please wait a little while. Helper is trying to fetch your favorite data hard...")
    try helper.enterHelper()
} catch {
    guard let err = error as? HelperError else {
        print("Unknown Error: \(error)".red.bold)
        exit(EX_USAGE)
    }
    
    switch err {
    case .unknownYear:
        print("WWDC \(year!) isn't been supported currently. Only support 2016 & 2017 now.".red.bold)
    case .unknownSubtitleLanguage:
        print("Language \(subtitleLanguage!) Only support Chinese or English now.".red.bold)
    case .unknownSessionID:
        print("".red.bold)
    }
    
    exit(EX_USAGE)
}
