//
//  ImageCache.swift
//  SpaceXLaunches
//
//  Created by Guilherme Teixeira de Mello on 20/07/24.
//

import SwiftUI


final class ImageCache {
    
    private static var cache: [URL: Image] = [:]
    
    static subscript(url: URL) -> Image? {
        get {
            ImageCache.cache[url]
        }
        set {
            ImageCache.cache[url] = newValue
        }
    }
}
