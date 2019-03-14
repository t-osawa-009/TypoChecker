//
//  Analytics.swift
//  TypoChecker
//
//  Created by Takuya Ohsawa on 2019/03/01.
//

import Foundation


class Analytics: NSObject {
    func elementsInEnumerator(atPath path: String) -> [String] {
        let enumerator = FileManager.default.enumerator(atPath: path)
        var elements = [String]()
        while let e = enumerator?.nextObject() as? String {
            elements.append(e)
        }
        return elements
    }
    
    func findLineNumber(from fileContents: String, targetWord: String) -> Int? {
        let lines = fileContents.components(separatedBy: .newlines)
        guard let result = lines.enumerated().first(where: { offset, text
            in
            text.contains(targetWord)
        }) else {
            return nil
        }
        
        return result.offset + 1
    }
}
