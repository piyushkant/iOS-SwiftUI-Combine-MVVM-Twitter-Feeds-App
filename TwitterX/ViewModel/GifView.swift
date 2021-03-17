//
//  GifView.swift
//  TwitterX
//
//  Created by Piyush Kant on 2021/03/17.
//

import SwiftUI
import SwiftyGif

struct GifView: UIViewRepresentable {
    var url: URL
    
    func makeUIView(context: Context) -> UIView {
        do {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: 350, height: 200))
            
            let gif = try UIImage(gifName: "giphy.gif")
            let imageview = UIImageView(gifImage: gif, loopCount: 3)
            imageview.frame = view.bounds
            view.addSubview(imageview)
            
            return view
        } catch {
            print(error)
        }
        
        return UIView()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}
