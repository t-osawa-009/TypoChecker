import AppKit

let parser = ArgumentParser(CommandLine.arguments)
parser.docString = "typo check"

let directoryOption = StringOption(named: "directoryPath",
                              flag: "directoryPath",
                              required: true,
                              helpString: "search directoryPath",
                              defaultValue: "")

let yamlOption = StringOption(named: "ymlPath",
                              flag: "ymlPath",
                              required: false,
                              helpString: "yaml search rootPath",
                              defaultValue: "")

let reportOption = StringOption(named: "report",
                                flag: "report",
                                required: false,
                                helpString: "output report type",
                                defaultValue: ReportType.json.rawValue)

let options: [StringOption] = [directoryOption, yamlOption, reportOption]

options.forEach { (option) in
    do {
        try parser.addOptions(option)
    } catch let error as ParsingError {
        print(error.description)
        exit(1)
    } catch {
        exit(1)
    }
}

let parsedArgs = try? parser.parse()
if parser.isValid {
    print("parser success")
}

let _rootDirectory = parsedArgs?["directoryPath"] as? String ?? ""
let _yamlDirectory = parsedArgs?["ymlPath"] as? String ?? ""
let _reportOption = parsedArgs?["report"] as? String ?? ""
let _reportType = ReportType(rawValue: _reportOption) ?? .json

let configuration = Configuration(rootDirectory: _rootDirectory,
                                  yamlDirectory: _yamlDirectory,
                                  reportType: _reportType)

let sourcePath = configuration.rootDirectory
let ignoredWords: [String] = configuration.ignoredWords

let analyticsNamingTypo = AnalyticsNamingTypo()
analyticsNamingTypo.perform()

let analyticsStringTypo = AnalyticsStringTypo()
analyticsStringTypo.perform()
