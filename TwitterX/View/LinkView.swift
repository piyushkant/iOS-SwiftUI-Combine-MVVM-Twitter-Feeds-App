//
//  LinkView.swift
//  TwitterX
//
//  Created by Piyush Kant on 2021/03/17.
//

import SwiftUI
import LinkPresentation

struct EmptyLinkPreview: UIViewRepresentable {
    var url: URL
    
    func makeUIView(context: Context) -> LPLinkView {
        let linkView = LPLinkView(url: url)
        linkView.sizeToFit()
        
        return linkView
    }
    
    func updateUIView(_ uiView: LPLinkView, context: Context) {
    }
}

struct LinkPreview: UIViewRepresentable {
    var link: Link
    
    func makeUIView(context: Context) -> LPLinkView {
        let linkView = LPLinkView(url: link.url)
        
        linkView.metadata = link.data
        linkView.sizeToFit()
        
        return linkView
    }
    
    func updateUIView(_ uiView: LPLinkView, context: Context) {
    }
}
