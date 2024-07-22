//
//  RocketInfoView.swift
//  SpaceXLaunches
//
//  Created by Guilherme Teixeira de Mello on 20/07/24.
//

import SwiftUI

struct RocketInfoView: View {
    @EnvironmentObject var viewModel: ViewModel
    let rocket: Rocket
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Name: \(rocket.name)")
                .font(.headline)
            Text(rocket.description)
            CacheAsyncImage(
                url: URL(string: rocket.flickrImages.first!)!,
                scale: 1.0,
                transaction: Transaction(animation: .easeIn(duration: 0.3)))
            { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .clipShape(.rect(cornerRadius: 10))
                case .failure(_ ):
                    Image(systemName: "photo")
                        .font(.system(size: 60))
                        .foregroundStyle(.secondary)
                case .empty:
                    ProgressView()
                @unknown default:
                    Image(systemName: "questionmark")
                }
            }
        }
    }
}

#Preview {
    RocketInfoView(rocket: Rocket.sampleRocket)
        .environmentObject(ViewModel())
}
