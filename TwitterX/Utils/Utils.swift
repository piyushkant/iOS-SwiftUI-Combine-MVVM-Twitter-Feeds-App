//
//  Utils.swift
//  TwitterX
//
//  Created by Piyush Kant on 2021/03/07.
//

import Foundation

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
    
    public static func checkForUrls(text: String) -> [URL] {
        let types: NSTextCheckingResult.CheckingType = .link
        
        do {
            let detector = try NSDataDetector(types: types.rawValue)
            
            let matches = detector.matches(in: text, options: .reportCompletion, range: NSMakeRange(0, text.count))
            
            return matches.compactMap({$0.url})
        } catch let error {
            debugPrint(error.localizedDescription)
        }
        
        return []
    }
}
