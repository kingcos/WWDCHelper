//
//  main.swift
//  WWDC_CLI
//
//  Created by kingcos on 07/09/2017.
//
//

import Foundation
import CommandLineKit
import Rainbow
import WWDC_CLI_Kit

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
                           helpMessage: "Setup the year of WWDC. Default is WWDC 2017.")
let isListOption = BoolOption(shortFlag: "l", longFlag: "list",
                              helpMessage: "List all sessions info.")
let sessionIDsOption = MultiStringOption(shortFlag: "s", longFlag: "session",
                                         helpMessage: "Setup session numbers in WWDC.")
let subtitleLanguageOption = StringOption(shortFlag: "g", longFlag: "language",
                                          helpMessage: "Setup the language of subtitle. Default is Chinese.")
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
               isListOption,
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
let isList = isListOption.value
let sessionIDs = sessionIDsOption.value
let subtitleLanguage = subtitleLanguageOption.value
let subtitleFilename = subtitleFilenameOption.value
let isSubtitleForSDVideo = isSubtitleForSDVideoOption.value
let isSubtitleForHDVideo = isSubtitleForHDVideoOption.value
let subtitlePath = subtitlePathOption.value
