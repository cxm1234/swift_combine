//
//  HUDView.swift
//  ChuckNorrisJokes_Mike
//
//  Created by Mike_Tree on 10/8/24.
//

import SwiftUI

struct HUDView: View {
    enum ImageType {
        case rofl, thumbDown
    }
    let imageType: ImageType
    
    var body: some View {
        image(for: imageType)
            .background(Color.clear)
    }
    
    private func image(for type: ImageType) -> Image {
        let image: UIImage
        switch imageType {
        case .rofl:
            image = ChuckNorrisJokesStyleKit.imageOfROFLIcon
        case .thumbDown:
            image = ChuckNorrisJokesStyleKit.imageOfThumbDownIcon
        }
        return Image(uiImage: image)
    }
}
