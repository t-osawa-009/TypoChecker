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
    
    init(fileName: String = Configuration.fileName, rootDirectory: String) {
        self.rootDirectory = rootDirectory
        let yamlPath = rootDirectory + "/" + fileName
        
        if let yaml = try? String(contentsOfFile: yamlPath, encoding: .utf8),
            let result = try? YAMLParser.parse(yaml) {
            language = result[YAMLKey.language.rawValue]?.string ?? Configuration.language
            let _ignoredWords = result[YAMLKey.ignoredWords.rawValue]?.array?.compactMap({ $0.string }) ?? []
            ignoredWords = _ignoredWords
            
            let _excluded = result[YAMLKey.excluded.rawValue]?.array?.compactMap({ $0.string }) ?? []
            excluded = _excluded
        } else {
            ignoredWords = []
            language = Configuration.language
            excluded = []
        }
    }
}
