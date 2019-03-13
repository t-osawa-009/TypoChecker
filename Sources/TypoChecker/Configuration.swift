//
//  Configuration.swift
//  TypoChecker
//
//  Created by Takuya Ohsawa on 2019/02/23.
//

import Foundation

struct Configuration {
    static let fileName = ".typochecker.yml"
    static let language = "en_US"
    
    let ignoredWords: [String]
    let excluded: [String]
    let language: String
    let rootDirectory: String
    let reportType: ReportType
    
    init(fileName: String = Configuration.fileName, rootDirectory: String?, yamlDirectory: String?) {
        let directoryPath: String = {
            if let rootDirectory = rootDirectory {
                return rootDirectory
            } else {
                return FileManager.default.currentDirectoryPath
            }
        }()
        
        self.rootDirectory = directoryPath
        
        let yamlDirectoryPath: String = {
            if let _yamlDirectory = yamlDirectory {
                return _yamlDirectory
            } else {
                return FileManager.default.currentDirectoryPath
            }
        }()
       
        let _yamlPath = yamlDirectoryPath + "/" + fileName
        if let yaml = try? String(contentsOfFile: _yamlPath, encoding: .utf8),
            let result = try? YAMLParser.parse(yaml) {
            language = result[YAMLKey.language.rawValue]?.string ?? Configuration.language
            let _ignoredWords = result[YAMLKey.ignoredWords.rawValue]?.array?.compactMap({ $0.string }) ?? []
            ignoredWords = _ignoredWords
            
            let _excluded = result[YAMLKey.excluded.rawValue]?.array?.compactMap({ $0.string }) ?? []
            let _report = result[YAMLKey.report.rawValue]?.string ?? ""
            excluded = _excluded
            reportType = ReportType(rawValue: _report) ?? .json
        } else {
            ignoredWords = []
            language = Configuration.language
            excluded = []
            reportType = .json
        }
    }
}
