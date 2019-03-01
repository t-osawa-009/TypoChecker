//
//  AnalyticsNamingTypo.swift
//  TypoCheckTests
//
//  Created by Takuya Ohsawa on 2019/03/01.
//

import Foundation
import AppKit

final class AnalyticsNamingTypo: Analytics {
    struct SourceInfo {
        let contents: String
        let fileName: String
        let names: [String]
        init(contents: String, fileName: String) {
            self.contents = contents
            self.fileName = fileName
            self.names = fetchNames(from: contents)
        }
    }
    
    func perform() {
        let files = findSourcefiles()
        var typoList: [String] = []
        files.forEach { (file) in
            file.names.forEach { (name) in
                let _words: [String] = fetchWords(from: name)
                _words.forEach({ (word) in
                    if let typo = findTypo(word: word), let lineNumber = findLineNumber(from: file.contents, targetWord: word) {
                        typoList.append(file.fileName + " \(lineNumber) : " + typo)
                    }
                })
            }
        }
        
        typoList.forEach { (typo) in
            print(typo)
        }
        
        if typoList.isEmpty {
            print("No typo")
        } else {
            print("Number of Typo Name: \(typoList.count)")
        }
    }
    
    // MARK: - private
    private static func fetchNames(from fileContents: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: "(?<=(^|\\s)(let|var|func|class|enum|struct|protocol)\\s)[a-zA-Z0-9_]+")
            let range = NSRange(0..<fileContents.count)
            let results = regex.matches(in: fileContents,
                                        options: .reportCompletion,
                                        range: range)
            return results.compactMap { (fileContents as NSString).substring(with: $0.range) }
        } catch {
            return []
        }
    }
    
    private func fetchWords(from name: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: "[a-zA-Z][a-z]+")
            let range = NSRange(0..<name.count)
            let results = regex.matches(in: name,
                                        options: .reportCompletion,
                                        range: range)
            return results.compactMap { (name as NSString).substring(with: $0.range) }
        } catch {
            return []
        }
    }
    
    func findSourcefiles() -> [SourceInfo] {
        if !FileManager.default.fileExists(atPath: sourcePath) {
            print("Invalid configuration: \(sourcePath) does not exist.")
            exit(1)
        }
        
        return elementsInEnumerator(atPath: sourcePath)
            .filter { $0.hasSuffix(".m") || $0.hasSuffix(".swift") || $0.hasSuffix(".xib") || $0.hasSuffix(".storyboard") }
            .filter { contents in
                return configuration.excluded.first(where: { contents.contains($0) }) == nil
            }
            .map { "\(sourcePath)/\($0)" }
            .map {
                if let result = try? String(contentsOfFile: $0, encoding: .utf8) {
                    return SourceInfo(contents: result, fileName: $0)
                } else {
                    return nil
                }
            }.compactMap{$0}
    }
    
    private func findTypo(word: String) -> String? {
        let checker = NSSpellChecker.shared
        checker.setIgnoredWords(configuration.ignoredWords, inSpellDocumentWithTag: 0)
        let typoRange = checker.checkSpelling(of: word, startingAt: 0)
        guard typoRange.location != NSNotFound else {
            return nil
        }
        
        var message: String = "Typo: [\(word)] "
        guard let candidates = checker.guesses(forWordRange: typoRange,
                                               in: word,
                                               language: configuration.language,
                                               inSpellDocumentWithTag: 0) else { return nil }
        if !candidates.isEmpty {
            message += "Did you mean: " + candidates.joined(separator: ", ")
        }
        
        return message
    }
}
