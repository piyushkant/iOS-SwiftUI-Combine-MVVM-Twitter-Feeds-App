//
//  Extension_Int.swift
//  TwitterX
//
//  Created by Piyush Kant on 2021/03/07.
//

import Foundation

extension Int {
    public func bytes(_ totalBytes: Int = MemoryLayout<Int>.size) -> [UInt8] {
        return Utils.arrayOfBytes(self, length: totalBytes)
    }
}

