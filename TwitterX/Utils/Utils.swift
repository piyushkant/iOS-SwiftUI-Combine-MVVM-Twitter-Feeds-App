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
    
    public static func convertUrlTextToHyperLink(text: String) -> String {
        let urls = checkForUrls(text: text)
        var hyperLinks = [String: String]()
        
        for url in urls {
            let urlString = url.absoluteString
            hyperLinks[urlString] = urlString
        }
        
        for link in hyperLinks {
            debugPrint("embeddedLinks",link)
//            debugPrint(".....")
//            debugPrint(link.va)
        }
        
        return addHyperLinksToText(originalText: text, hyperLinks: hyperLinks)
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
    
    public static func addHyperLinksToText(originalText: String, hyperLinks: [String: String]) -> String {
        let style = NSMutableParagraphStyle()
        style.alignment = .left
        let attributedOriginalText = NSMutableAttributedString(string: originalText)
        
        debugPrint("attributedOriginalText", attributedOriginalText)
        
        for (hyperLink, urlString) in hyperLinks {
            let linkRange = attributedOriginalText.mutableString.range(of: hyperLink)
            let fullRange = NSRange(location: 0, length: attributedOriginalText.length)
            attributedOriginalText.addAttribute(NSAttributedString.Key.link, value: urlString, range: linkRange)
            attributedOriginalText.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: fullRange)
            //            attributedOriginalText.addAttribute(NSAttributedString.Key.font, value: YourFont, range: fullRange)
        }
        
        //        self.linkTextAttributes = [
        ////            NSAttributedString.Key.foregroundColor: YourColor,
        //            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
        //        ]
        //        self.attributedText = attributedOriginalText
        return attributedOriginalText.string
    }
}
