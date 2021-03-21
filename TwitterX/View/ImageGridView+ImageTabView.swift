//
//  ImageGridView + ImagePageTabView.swift
//  TwitterX
//
//  Created by Piyush Kant on 2021/03/17.
//

import SwiftUI

struct ImageGridView: View {
    @ObservedObject var homeViewModel: HomeViewModel
    var image: AttachedImage
    var images: [AttachedImage]
    @State private var showImageTabView = false
    
    var body: some View {
        Button(action: {
            self.showImageTabView.toggle()
        }, label: {
            ZStack {
                Image(uiImage: image.image ?? UIImage())
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: (UIScreen.main.bounds.width - 100)/2, height: 120)
                    .cornerRadius(12)
            }
        })
        .sheet(isPresented: $showImageTabView) {
            ImageTabView(homeViewModel: homeViewModel, images: images)
        }
    }
}

struct ImageTabView: View {
    @ObservedObject var homeViewModel: HomeViewModel
    let images: [AttachedImage]
   
    @GestureState var draggingOffset: CGSize = .zero
    @State var imageViewerOffset: CGSize = .zero
    @State var bgOpacity: Double = 1
    @State var imageScale: CGFloat = 1
    
    init(homeViewModel: HomeViewModel, images: [AttachedImage]) {
        self.homeViewModel = homeViewModel
        self.images = images
    }
    
    var body: some View {
        ZStack {
            Color(.gray)
                .opacity(bgOpacity)
                .ignoresSafeArea()
            
            TabView {
                ForEach(images, id: \.self) {image in
                    Image(uiImage: image.image ?? UIImage())
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .tag(image.image)
                        .scaleEffect(imageScale)
                        .offset(y: imageViewerOffset.height)
                        .gesture(
                            MagnificationGesture().onChanged({(value) in
                                imageScale = value
                            })
                            .onEnded({(_) in
                                withAnimation(.spring()){
                                    imageScale = 1
                                }
                            })
                            .simultaneously(with: DragGesture(minimumDistance: imageScale == 1 ? 1000 : 0))
                            .simultaneously(with: TapGesture(count: 2).onEnded({
                                withAnimation {
                                    imageScale = imageScale > 1 ? 1 : 4
                                }
                            }))
                        )
                }
            }
            .tabViewStyle(PageTabViewStyle())
        }
    }
}
