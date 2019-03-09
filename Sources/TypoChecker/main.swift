import AppKit

let parser = ArgumentParser(CommandLine.arguments)
parser.docString = "typo check"

let pathOption = StringOption(named: "rootPath",
                              flag: "r",
                              required: true,
                              helpString: "search rootPath", defaultValue: "")

let yamlOption = StringOption(named: "yamlPath",
                              flag: "y",
                              required: false,
                              helpString: "yaml search rootPath", defaultValue: "")

let options: [StringOption] = [pathOption, yamlOption]

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

let _rootDirectory = parsedArgs?["rootPath"] as? String ?? ""
let _yamlDirectory = parsedArgs?["yamlPath"] as? String ?? ""
let configuration = Configuration(rootDirectory: _rootDirectory,    yamlDirectory: _yamlDirectory)

let sourcePath = configuration.rootDirectory
let ignoredWords: [String] = configuration.ignoredWords

let analyticsNamingTypo = AnalyticsNamingTypo()
analyticsNamingTypo.perform()

let analyticsStringTypo = AnalyticsStringTypo()
analyticsStringTypo.perform()
