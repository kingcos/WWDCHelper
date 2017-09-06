import Foundation
import CommandLineKit
import Rainbow

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
                           helpMessage: "Year of WWDC. Default is WWDC 2017.")
cli.addOption(yearOption)

let listOption = BoolOption(shortFlag: "l", longFlag: "list",
                            helpMessage: "List all sessions info.")
cli.addOption(listOption)

let sessionOption = MultiStringOption(shortFlag: "s", longFlag: "session",
                                      helpMessage: "Session number in WWDC.")
cli.addOption(sessionOption)

let languageOption = StringOption(shortFlag: "g", longFlag: "language",
                                  helpMessage: "Subtitle in which language. Default is Chinese.")
cli.addOption(languageOption)

let helpOption = BoolOption(shortFlag: "h", longFlag: "help",
                            helpMessage: "Print this help info.")
cli.addOption(helpOption)

let versionOption = BoolOption(shortFlag: "v", longFlag: "version",
                               helpMessage: "Print version info.")
cli.addOption(versionOption)

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
let isList = listOption.value
let sessions = sessionOption.value
let language = languageOption.value
