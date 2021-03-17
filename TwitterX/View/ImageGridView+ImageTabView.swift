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
       
    var body: some View {
        Button(action: {
            withAnimation(.easeInOut) {
                homeViewModel.showImageViewer.toggle()
            }

        }, label: {
            ZStack {
                Image(uiImage: image.image ?? UIImage())
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: (UIScreen.main.bounds.width - 100)/2, height: 120)
                    .cornerRadius(12)
            }
        })
    }
}

struct ImageTabView: View {
    @ObservedObject var homeViewModel: HomeViewModel
    let images: [AttachedImage]
    @GestureState var draggingOffset: CGSize = .zero
    
    init(homeViewModel: HomeViewModel, images: [AttachedImage]) {
        self.homeViewModel = homeViewModel
        self.images = images
    }

    var body: some View {
        ZStack {
            if homeViewModel.showImageViewer {
                Color(.gray)
                    .opacity(homeViewModel.bgOpacity)
                    .ignoresSafeArea()

                TabView {
                    ForEach(images, id: \.self) {image in
                        Image(uiImage: image.image ?? UIImage())
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .tag(image.image)
                            .scaleEffect(homeViewModel.imageScale)
                            .offset(y: homeViewModel.imageViewerOffset.height)
                            .gesture(
                                MagnificationGesture().onChanged({(value) in
                                    homeViewModel.imageScale = value
                                })
                                .onEnded({(_) in
                                    withAnimation(.spring()){
                                        homeViewModel.imageScale = 1
                                    }
                                })
                                .simultaneously(with: DragGesture(minimumDistance: homeViewModel.imageScale == 1 ? 1000 : 0))
                                .simultaneously(with: TapGesture(count: 2).onEnded({
                                    withAnimation {
                                        homeViewModel.imageScale = homeViewModel.imageScale > 1 ? 1 : 4
                                    }
                                }))
                            )
                    }
                }
                .tabViewStyle(PageTabViewStyle())
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(
            Button(action: {
                homeViewModel.showImageViewer.toggle()
            }, label: {
                Image(systemName: "xmark")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.white.opacity(0.35))
                    .clipShape(Rectangle())
            })
            .padding(10)
            .opacity(homeViewModel.showImageViewer ? homeViewModel.bgOpacity : 0)

            , alignment: .topTrailing
        )
    }
}
