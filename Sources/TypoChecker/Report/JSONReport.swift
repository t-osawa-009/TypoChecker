//
//  JSONReport.swift
//  TypoChecker
//
//  Created by Takuya Ohsawa on 2019/03/12.
//

import Foundation

struct JSONReport: Reportable {
    let fileName: String
    let lineNumber: Int
    let typoString: String
    
    func output() -> String {
        if let jsonData = try? JSONSerialization.data(withJSONObject: toDictionary(fileName: fileName, lineNumber: lineNumber, typoString: typoString) , options: []), let jsonStr = String(bytes: jsonData, encoding: .utf8) {
            return jsonStr
        } else {
            return ""
        }
    }
    
    private func toDictionary(fileName: String, lineNumber: Int, typoString: String) -> [String: Any] {
        return [
            "fileName": fileName,
            "lineNumber": lineNumber,
            "typo": typoString,
        ]
    }
}
