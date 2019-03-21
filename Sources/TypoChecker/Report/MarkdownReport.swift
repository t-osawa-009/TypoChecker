//
//  MarkdownReport.swift
//  Files
//
//  Created by Takuya Ohsawa on 2019/03/21.
//

import Foundation

struct MarkdownReport: Reportable {
    let fileName: String
    let lineNumber: Int
    let typoString: String
    
    func output() -> String {
        return [
            fileName,
            lineNumber.description,
            typoString
            ].joined(separator: " | ")
    }
}
