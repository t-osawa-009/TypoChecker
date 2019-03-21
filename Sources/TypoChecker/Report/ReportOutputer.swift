//
//  ReportOutputer.swift
//  Files
//
//  Created by Takuya Ohsawa on 2019/03/22.
//

import Foundation

final class ReportOutputer {
    private let reportType: ReportType
    private let results: [String]
    init(reportType: ReportType, results: [String]) {
        self.reportType = reportType
        self.results = results
    }
    
    func report() {
        switch reportType {
        case .markdown:
            let keys = [
                "file",
                "line",
                "Typo",
                ].joined(separator: " | ")
            
            let rows = [keys, "--- | --- | ---"] + results
            print(rows.joined(separator: "\n"))
        case .json, .xcode:
            results.forEach { (typo) in
                print(typo)
            }
        }
    }
}
