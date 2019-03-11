//
//  XcodeReport.swift
//  TypoChecker
//
//  Created by Takuya Ohsawa on 2019/03/12.
//

import Foundation

struct XcodeReport: Reportable {
    let fileName: String
    let lineNumber: Int
    let typoString: String
    
    func output() -> String {
        return fileName
            + ":\(lineNumber): "
            + "warning: \"\(typoString)\""
    }
}
