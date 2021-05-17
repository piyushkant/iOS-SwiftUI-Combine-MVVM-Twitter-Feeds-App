//
//  Extensions.swift
//  TwitterX
//
//  Created by Piyush Kant on 2021/03/07.
//

import Foundation

extension Data {
    
    var rawBytes: [UInt8] {
        return [UInt8](self)
    }
    
    init(bytes: [UInt8]) {
        self.init(bytes)
    }
    
}
