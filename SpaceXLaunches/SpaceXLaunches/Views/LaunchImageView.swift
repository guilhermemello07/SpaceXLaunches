//
//  LaunchImageView.swift
//  SpaceXLaunches
//
//  Created by Guilherme Teixeira de Mello on 20/07/24.
//

import SwiftUI

struct LaunchImageView: View {
    @EnvironmentObject var viewModel: ViewModel
    @StateObject var networkManager = NetworkManager()
    
    let launch: Launch
    
    var body: some View {
        CacheAsyncImage(
            url: URL(string: launch.links.patch.small ?? "")!,
            scale: 1.0,
            transaction: Transaction(animation: .easeIn(duration: 0.3)))
        { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
            case .failure(_ ):
                if networkManager.isConnected {
                    Image(systemName: "exclamationmark.circle")
                        .font(.system(size: 50))
                        .foregroundStyle(.secondary)
                } else {
                    Image(systemName: "wifi.slash")
                        .font(.system(size: 50))
                        .foregroundStyle(.secondary)
                }
            case .empty:
                if let cachedImage = ImageCache[URL(string: launch.links.patch.small ?? "")!] {
                    cachedImage
                        .resizable()
                        .scaledToFit()
                } else {
                    ProgressView()
                }
            @unknown default:
                Image(systemName: "questionmark.circle")
                    .font(.system(size: 60))
                    .foregroundStyle(.secondary)
            }
        }
    }
}


#Preview {
    LaunchImageView(launch: Launch.sampleLaunch)
        .environmentObject(ViewModel())
}
