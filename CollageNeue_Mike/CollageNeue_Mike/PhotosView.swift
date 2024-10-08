//
//  PhotosView.swift
//  CollageNeue_Mike
//
//  Created by ming on 2024/8/16.
//

import SwiftUI
import Photos
import Combine

struct PhotosView: View {
    @EnvironmentObject var model: CollageNeueModel
    @Environment(\.presentationMode) var presentationMode
    
    let columns: [GridItem] = [.init(.adaptive(minimum: 100, maximum: 200))]
    
    @State private var subscriptions = [AnyCancellable]()
    
    @State private var photos = PHFetchResult<PHAsset>()
    @State private var imageManager = PHCachingImageManager()
    @State private var isDisplayingError = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 2) {
                    ForEach((0..<photos.count), id: \.self) { index in
                        let asset = photos[index]
                        let _ = model.enqueueThumbnail(asset: asset)
                        
                        Button(action: {
                            model.selectImage(asset: asset)
                        }, label: {
                            Image(uiImage: model.thumbnails[asset.localIdentifier] ?? UIImage(named: "IMG_1907")!)
                                .resizable()
                                .aspectRatio(1, contentMode: .fill)
                                .clipShape(
                                    RoundedRectangle(cornerRadius: 5)
                                )
                                .padding(4)
                        })
                    }
                }
                .padding()
            }
            .navigationTitle("Photos")
            .toolbar(content: {
                Button("Close", role: .cancel) {
                    self.presentationMode.wrappedValue.dismiss()
                }
            })
        }
        .alert("No access to Camera Roll", isPresented: $isDisplayingError, actions: {}, message: {
            Text("You can grant access to Collage Neue from the Settings app")
        })
        .onAppear(perform: {
            _ = PHPhotoLibrary.isAuthorized.sink { status in
                if status {
                    DispatchQueue.main.async {
                        self.photos = model.loadPhotos()
                    }
                }
            }
            model.bindPhotoPicker()
        })
        .onDisappear(perform: {
            model.selectedPhotos.send(completion: .finished)
        })
        
    }
}

#Preview {
    PhotosView()
}
