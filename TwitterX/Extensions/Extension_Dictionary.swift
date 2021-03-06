//
//  Extension_Dictionary.swift
//  TwitterX
//
//  Created by Piyush Kant on 2021/03/07.
//

import Foundation

extension Dictionary {
    func urlEncodedQueryString(using encoding: String.Encoding) -> String {
        var parts = [String]()
        
        for (key, value) in self {
            let keyString = "\(key)".urlEncodedString()
            let valueString = "\(value)".urlEncodedString(keyString == "status")
            let query: String = "\(keyString)=\(valueString)"
            parts.append(query)
        }
        
        return parts.joined(separator: "&")
    }
}
