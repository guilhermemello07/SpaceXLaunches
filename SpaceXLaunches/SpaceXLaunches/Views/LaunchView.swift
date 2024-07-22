//
//  LaunchView.swift
//  SpaceXLaunches
//
//  Created by Guilherme Teixeira de Mello on 20/07/24.
//

import SwiftUI

struct LaunchView: View {
    @EnvironmentObject var viewModel: ViewModel
    let launch: Launch
    
    var hasImage: Bool {
        return launch.links.patch.small != nil 
    }
    
    var body: some View {
        HStack {
            if hasImage {
                LaunchImageView(launch: launch)
                    .frame(width: 60, height: 60)
            } else {
                Image(systemName: "airplane.departure")
                    .font(.system(size: 40))
                    .foregroundStyle(.secondary)
            }
            VStack(alignment: .leading) {
                Text(launch.name)
                    .font(.headline)
                
                Text("Local date: \(launch.dateStringLocalTimeZone)")
                    .font(.caption)
                Text("Irish date: \(launch.dateStringIrishTimeZone)")
                    .font(.caption)
            }
        }
    }
}

#Preview {
    LaunchView(launch: Launch.sampleLaunch)
        .environmentObject(ViewModel())
}
