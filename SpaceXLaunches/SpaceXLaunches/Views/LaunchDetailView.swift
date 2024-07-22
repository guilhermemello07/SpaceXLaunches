//
//  LaunchDetailView.swift
//  SpaceXLaunches
//
//  Created by Guilherme Teixeira de Mello on 20/07/24.
//

import SwiftUI

struct LaunchDetailView: View {
    @EnvironmentObject var viewModel: ViewModel
    let launch: Launch
    
    var hasImage: Bool {
        return launch.links.patch.small != nil
    }

    var isUpcoming: Bool {
        return launch.upcoming
    }

    var hasRocket: Bool {
        return !launch.rocket.isEmpty
    }

    var hasLaunchpad: Bool {
        return !launch.launchpad.isEmpty
    }

    var missionSuccessStatus: Bool {
        return launch.success ?? true
    }
    
    var body: some View {
        ScrollView {
            if hasImage {
                LaunchImageView(launch: launch)
                    .frame(maxHeight: 200)
            } else {
                Image(systemName: "airplane.departure")
                    .font(.system(size: 200))
                    .foregroundStyle(.secondary)
            }
            Divider()
            
            VStack(alignment: .leading) {
                Text("Mission: \(launch.name)")
                    .font(.title.bold())
                    .padding(.bottom, 5)
                
                if isUpcoming {
                    Text("This is an upcoming flight that will take place at")
                        .font(.headline)
                        .padding(.top, 5)
                    Text("**Local date:** \(launch.dateStringLocalTimeZone)")
                    Text("**Irish date:** \(launch.dateStringIrishTimeZone)")
                } else {
                    Text("This flight occured at")
                        .font(.headline)
                        .padding(.top, 5)
                    Text("**Local launch date:** \(launch.dateStringLocalTimeZone)")
                    Text("**Irish launch date:** \(launch.dateStringIrishTimeZone)")
                    Text("Launch status: \(missionSuccessStatus ? "Success" : "Failure")")
                        .font(.title3.bold())
                        .padding(.top, 5)
                    Text(launch.details ?? "The mission was a Success")
                }
                
                if hasRocket {
                    Divider()
                    Text("Rocket Info")
                        .font(.title3.bold())
                    if viewModel.rocket != nil {
                        RocketInfoView(rocket: viewModel.rocket!)
                    }
                }
                
                if hasLaunchpad {
                    Divider()
                    Text("Launchpad Info")
                        .font(.title3.bold())
                    if viewModel.launchpad != nil {
                        LaunchpadInfoView(launchPad: viewModel.launchpad!)
                    }
                }
                
            }
            .padding()
            .navigationTitle(launch.name)
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            Task {
                try await viewModel.fetchRocketInfoAsync(withRocketId: launch.rocket)
                try await viewModel.fetchLaunchpadInfoAsync(withLaunchpadId: launch.launchpad)
            }
        }
    }
}

#Preview {
    LaunchDetailView(launch: Launch.sampleLaunch)
        .environmentObject(ViewModel())
}
