//
//  LoadingView.swift
//  TrialsOfTheEveryday
//
//  Created by Sebastian Maier on 21.09.24.
//

import SwiftUI

struct LoadingView: View {
    @Binding var loading: Bool
    @StateObject var viewModel: DataContainerViewModel
    
    var body: some View {
        VStack {
            Text("Loading...")
            
            ProgressView()
                .onAppear {
                    viewModel.fetchEnemies()
                    viewModel.fetchCharacterSkills {
                        withAnimation {
                            loading = true
                        }
                    }
                    viewModel.fetchCharacterItems {
                        withAnimation {
                            loading = false
                        }
                    }
                }
        }
    }
}
