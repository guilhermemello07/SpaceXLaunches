//
//  LaunchpadInfoView.swift
//  SpaceXLaunches
//
//  Created by Guilherme Teixeira de Mello on 20/07/24.
//

import SwiftUI
import MapKit

struct LaunchpadInfoView: View {
    @EnvironmentObject var viewModel: ViewModel
    let launchPad: Launchpad
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("**Name:** \(launchPad.fullName)")
            Text("**Location:** \(launchPad.locality)")
            Text("**Region:** \(launchPad.region)")
            Text("Description")
                .font(.headline)
                .padding(.top, 5)
            Text(launchPad.details)
            
            Map {
                Marker(
                    launchPad.locality,
                    coordinate: CLLocationCoordinate2D(
                        latitude: launchPad.latitude,
                        longitude: launchPad.longitude)
                )
            }
            .mapControlVisibility(.hidden)
            .frame(minHeight: 400)
            .clipShape(.rect(cornerRadius: 10))
            .padding(.bottom, 5)
        }
    }
}

#Preview {
    LaunchpadInfoView(launchPad: Launchpad.sampleLaunchPad)
        .environmentObject(ViewModel())
}
