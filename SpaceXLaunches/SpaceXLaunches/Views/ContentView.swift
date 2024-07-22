//
//  ContentView.swift
//  SpaceXLaunches
//
//  Created by Guilherme Teixeira de Mello on 20/07/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ViewModel()
    
    @State private var showAlert = false
    @State private var showInternetConnectionAlert = false
    @State private var showingPastLaunches = true
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.launches, id: \.id) { launch in
                    NavigationLink(destination: LaunchDetailView(launch: launch)) {
                        LaunchView(launch: launch)
                    }
                }
            }
            .navigationTitle(showingPastLaunches ? "Past Launches" : "Upcoming")
            .toolbar {
                Button(showingPastLaunches ? "Upcoming" : "Past Launches") {
                    showingPastLaunches.toggle()
                    Task { await viewModel.loadData(showPastLaunches: showingPastLaunches) }
                }
            }

        }
        .environmentObject(viewModel)
        .onReceive(viewModel.$error, perform: { error in
            if error != nil {
                showAlert.toggle()
            }
        })
        .alert(isPresented: $showAlert, content: {
            Alert(title: Text("Error"),
                  message: Text(viewModel.error?.localizedDescription ?? ""))
        })
    }
}

#Preview {
    ContentView()
}
