//
//  ImageGridView + ImagePageTabView.swift
//  TwitterX
//
//  Created by Piyush Kant on 2021/03/17.
//

import SwiftUI

struct ImageGridView: View {
    @ObservedObject var homeTimelineViewModel: HomeTimelineViewModel
    var image: AttachedImage
    
    var body: some View {
        Button(action: {
            homeTimelineViewModel.selectedImageID = image.id
            homeTimelineViewModel.showImageViewer.toggle()
            
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
    @ObservedObject var homeTimelineViewModel: HomeTimelineViewModel
    let images: [AttachedImage]
    @GestureState var draggingOffset: CGSize = .zero
    
    var body: some View {
        ZStack {
            if homeTimelineViewModel.showImageViewer {
                Color(.black)
                    .opacity(homeTimelineViewModel.bgOpacity)
                    .ignoresSafeArea()
                
                ScrollView(.init()) {
                    TabView(selection: $homeTimelineViewModel.selectedImageID) {
                        ForEach(images, id: \.self) {image in
                            Image(uiImage: image.image ?? UIImage())
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .tag(image)
                                .scaleEffect(homeTimelineViewModel.selectedImageID == image.id ? (homeTimelineViewModel.imageScale > 1 ? homeTimelineViewModel.imageScale : 1) : 1)
                                .offset(y: homeTimelineViewModel.imageViewerOffset.height)
                                .gesture(
                                    MagnificationGesture().onChanged({(value) in
                                        homeTimelineViewModel.imageScale = value
                                    }).onEnded({(_) in
                                        withAnimation(.spring()){
                                            homeTimelineViewModel.imageScale = 1
                                        }
                                    })
                                    
                                    .simultaneously(with: DragGesture(minimumDistance: homeTimelineViewModel.imageScale == 1 ? 1000 : 0))
                                    
                                    .simultaneously(with: TapGesture(count: 2).onEnded({
                                        withAnimation {
                                            homeTimelineViewModel.imageScale = homeTimelineViewModel.imageScale > 1 ? 1 : 4
                                        }
                                    }))
                                )
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                }
                .ignoresSafeArea()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(
            Button(action: {
                homeTimelineViewModel.showImageViewer.toggle()
            }, label: {
                Image(systemName: "xmark")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.white.opacity(0.35))
                    .clipShape(Circle())
            })
            .padding(10)
            .opacity(homeTimelineViewModel.showImageViewer ? homeTimelineViewModel.bgOpacity : 0)
            
            , alignment: .topTrailing
        )
    }
}
