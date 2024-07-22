//
//  CacheAsyncImage.swift
//  SpaceXLaunches
//
//  Created by Guilherme Teixeira de Mello on 20/07/24.
//

import SwiftUI

struct CacheAsyncImage<Content>: View where Content: View {
    
    //These are the same parameters to initialize AsyncImage
    private let url: URL
    private let scale: CGFloat
    private let transaction: Transaction
    private let content: (AsyncImagePhase) -> Content
    
    init(
        url: URL,
        scale: CGFloat = 1.0,
        transaction: Transaction = Transaction(),
        @ViewBuilder content: @escaping (AsyncImagePhase) -> Content
    ) {
        self.url = url
        self.scale = scale
        self.transaction = transaction
        self.content = content
    }
    
    var body: some View {
        if let cached = ImageCache[url] {
            content(.success(cached))
        } else {
            AsyncImage(
                url: url,
                scale: scale,
                transaction: transaction)
            { phase in
                cacheAndRender(phase: phase)
            }
        }
    }
    
    //AsyncImage is a special closure. This is a function to help AsyncImage
    func cacheAndRender(phase: AsyncImagePhase) -> some View {
        if case .success(let image) = phase {
            ImageCache[url] = image
        }
        return content(phase)
    }
}

#Preview {
    CacheAsyncImage(url: URL(string: Launch.sampleLaunch.links.patch.small!)! ) { phase in
        switch phase {
        case .success(let image):
            image
        case .failure(_ ):
            Image(systemName: "exclamationmark.circle")
        case .empty:
            Image(systemName: "questionmark")
        @unknown default:
            Image(systemName: "questionmark")
        }
    }
}
