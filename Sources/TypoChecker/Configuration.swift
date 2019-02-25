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
    let language: String
    let rootDirectory: String
    
    init(fileName: String = Configuration.fileName, rootDirectory: String? = nil) {
        let _rootDirectory = rootDirectory ?? FileManager.default.currentDirectoryPath
        self.rootDirectory = _rootDirectory
        let yamlPath = _rootDirectory + "/" + fileName
        
        if let yaml = try? String(contentsOfFile: yamlPath, encoding: .utf8),
            let result = try? YAMLParser.parse(yaml) {
            language = result[YAMLKey.language.rawValue]?.string ?? Configuration.language
            let _ignoredWords = result[YAMLKey.ignoredWords.rawValue]?.array?.compactMap({ $0.string }) ?? []
            ignoredWords = _ignoredWords
        } else {
            ignoredWords = []
            language = Configuration.language
        }
    }
}
