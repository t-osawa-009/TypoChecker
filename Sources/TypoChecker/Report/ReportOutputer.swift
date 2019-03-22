//
//  ReportOutputer.swift
//  Files
//
//  Created by Takuya Ohsawa on 2019/03/22.
//

import Foundation
import Files

enum CheckType: String {
    case name
    case string
}

final class ReportOutputer {
    private let reportType: ReportType
    private let results: [String]
    init(reportType: ReportType, results: [String]) {
        self.reportType = reportType
        self.results = results
    }
    
    func report(checkType: CheckType) {
        switch reportType {
        case .markdown:
            let keys = [
                "file",
                "line",
                "Typo",
                ].joined(separator: " | ")
            
            let rows = [keys, "--- | --- | ---"] + results
            let result = rows.joined(separator: "\n")
            print(result)
            if !configuration.outputPath.isEmpty,
                let folder = try? Folder(path: configuration.outputPath),
                let file = try? folder.createFile(named: checkType.rawValue + "_" + Configuration.markdownName) {
                _ = try? file.write(string: result)
            }
        case .json, .xcode:
            results.forEach { (typo) in
                print(typo)
            }
        }
    }
}
