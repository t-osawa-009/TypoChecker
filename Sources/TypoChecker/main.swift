import AppKit

let parser = ArgumentParser(CommandLine.arguments)
parser.docString = "typo check"

let pathOption = StringOption(named: "path",
                              flag: "path",
                              required: true,
                              helpString: "search file path",
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

let outputOption = StringOption(named: "output",
                                flag: "output",
                                required: false,
                                helpString: "output path",
                                defaultValue: "")

let options: [StringOption] = [pathOption, yamlOption, reportOption]

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

let _rootDirectory = parsedArgs?["path"] as? String ?? ""
let _yamlDirectory = parsedArgs?["ymlPath"] as? String ?? ""
let _reportOption = parsedArgs?["report"] as? String ?? ""
let _reportType = ReportType(rawValue: _reportOption) ?? .markdown
let _output = parsedArgs?["output"] as? String ?? ""

let configuration = Configuration(rootDirectory: _rootDirectory,
                                  yamlDirectory: _yamlDirectory,
                                  reportType: _reportType,
                                  outputPath: _output)

let sourcePath = configuration.rootDirectory
let ignoredWords: [String] = configuration.ignoredWords

let elements = Analytics.findSourcefiles(atPath: sourcePath)

let analyticsNamingTypo = AnalyticsNamingTypo()
analyticsNamingTypo.perform(elements: elements)

let analyticsStringTypo = AnalyticsStringTypo()
analyticsStringTypo.perform(elements: elements)
