//
//  ReportGenerator.swift
//  TypoChecker
//
//  Created by Takuya Ohsawa on 2019/03/13.
//

import Foundation

final class ReportGenerator {
    private let reportType: ReportType
    init(reportType: ReportType) {
        self.reportType = reportType
    }
    
    func generate(fileName: String, lineNumber: Int, typoString: String) -> Reportable {
        switch reportType {
        case .xcode:
            return XcodeReport(fileName: fileName, lineNumber: lineNumber, typoString: typoString)
        case .json:
            return JSONReport(fileName: fileName, lineNumber: lineNumber, typoString: typoString)
        }
    }
}
