//
//  Utils.swift
//  TwitterX
//
//  Created by Piyush Kant on 2021/03/07.
//

import SwiftUI

struct Utils {
    
    public static func arrayOfBytes<T>(_ value:T, length: Int? = nil) -> [UInt8] {
        let totalBytes = length ?? (MemoryLayout<T>.size * 8)
        let valuePointer = UnsafeMutablePointer<T>.allocate(capacity: 1)
        valuePointer.pointee = value
        
        let bytesPointer = valuePointer.withMemoryRebound(to: UInt8.self, capacity: 1) { $0 }
        var bytes = [UInt8](repeating: 0, count: totalBytes)
        for j in 0..<min(MemoryLayout<T>.size,totalBytes) {
            bytes[totalBytes - 1 - j] = (bytesPointer + j).pointee
        }
        
        valuePointer.deinitialize(count: 1)
        valuePointer.deallocate()
        
        return bytes
    }
    
    public static func convertStringToDate(dateString: String) -> Date? {
        let tdf = DateFormatter()
        tdf.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"
        tdf.locale = Locale(identifier: "en_US_POSIX")
        if let date = tdf.date(from: dateString) {
            let df = DateFormatter()
            df.dateStyle = .medium
            df.timeStyle = .medium
            return df.date(from: df.string(from: date))
        }
        return nil
    }
}
