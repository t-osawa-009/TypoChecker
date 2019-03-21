//
//  Analytics.swift
//  TypoChecker
//
//  Created by Takuya Ohsawa on 2019/03/01.
//

import Foundation
import Files

struct FileObject {
    let path: String
    let content: String
    let contentStrings: [String]
    let contentNames: [String]
    
    init(path: String, content: String) {
        self.path = path
        self.content = content
        self.contentStrings = type(of: self).findStrings(from: content)
        self.contentNames = type(of: self).findNames(from: content)
    }
    
    private static func findStrings(from line: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: "\"[^\"]+\"")
            let range = NSRange(0..<line.count)
            let results = regex.matches(in: line, options: .reportCompletion, range: range)
            return results.compactMap { (line as NSString).substring(with: $0.range) }
        } catch {
            return []
        }
    }
    
    private static func findNames(from fileContents: String) -> [String] {
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
}

class Analytics: NSObject {
    static func findSourcefiles(atPath: String) -> [FileObject] {
        if !FileManager.default.fileExists(atPath: atPath) {
            print("Invalid configuration: \(atPath) does not exist.")
            exit(1)
        }
        
        return elementsInEnumerator(atPath: atPath)
    }
    
    private static func elementsInEnumerator(atPath path: String) -> [FileObject] {
        if let file = try? File(path: path) {
            if let content = try? file.readAsString(encoding: .utf8) {
                return [FileObject(path: path, content: content)]
            } else {
                return []
            }
        } else if let folder = try? Folder(path: path) {
            var element: [FileObject] = []
            folder.makeFileSequence(recursive: true, includeHidden: false).forEach { (file) in
                if let content = try? file.readAsString(encoding: .utf8) {
                    element.append(FileObject(path: path + file.name, content: content))
                }
            }
            return element
        } else {
            return []
        }
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
