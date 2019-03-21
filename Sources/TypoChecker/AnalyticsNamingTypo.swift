//
//  AnalyticsNamingTypo.swift
//  TypoChecker
//
//  Created by Takuya Ohsawa on 2019/03/01.
//

import Foundation
import AppKit

final class AnalyticsNamingTypo: Analytics {
    func perform() {
        let elements = findSourcefiles()
        var typoList: [String] = []
        elements.forEach { (_element) in
            _element.contentNames.forEach({ (name) in
                let _words: [String] = fetchWords(from: name)
                _words.forEach({ (word) in
                    if let typo = findTypo(word: word), let lineNumber = findLineNumber(from: _element.content, targetWord: word) {
                        let generator = ReportGenerator(reportType: configuration.reportType)
                        let report = generator.generate(fileName: _element.path, lineNumber: lineNumber, typoString: typo)
                        typoList.append(report.output())
                    }
                })
            })
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
