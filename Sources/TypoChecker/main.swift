import AppKit

let configuration = Configuration(rootDirectory: "/Users/dazezhuoye/DeskTop/TypoChecker")
let enabled = true
let sourcePath = configuration.rootDirectory
let ignoredWords: [String] = configuration.ignoredWords
if !enabled {
    print("Typo check cancelled")
    exit(000)
}

let analyticsNamingTypo = AnalyticsNamingTypo()
analyticsNamingTypo.perform()

let analyticsStringTypo = AnalyticsStringTypo()
analyticsStringTypo.perform()
