//
//  Extension_UITextView.swift
//  TwitterX
//
//  Created by Piyush Kant on 2021/03/08.
//

import UIKit

extension UITextView {
    
    func addHyperLinksToText(originalText: String, hyperLinks: [String: String]) {
        let style = NSMutableParagraphStyle()
        style.alignment = .left
        let attributedOriginalText = NSMutableAttributedString(string: originalText)
        for (hyperLink, urlString) in hyperLinks {
            let linkRange = attributedOriginalText.mutableString.range(of: hyperLink)
            let fullRange = NSRange(location: 0, length: attributedOriginalText.length)
            attributedOriginalText.addAttribute(NSAttributedString.Key.link, value: urlString, range: linkRange)
            attributedOriginalText.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: fullRange)
//            attributedOriginalText.addAttribute(NSAttributedString.Key.font, value: YourFont, range: fullRange)
        }

        self.linkTextAttributes = [
//            NSAttributedString.Key.foregroundColor: YourColor,
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
        ]
        self.attributedText = attributedOriginalText
    }
}
