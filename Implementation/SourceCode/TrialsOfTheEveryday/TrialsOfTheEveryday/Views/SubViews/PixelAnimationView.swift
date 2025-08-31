//
//  PixelAnimationView.swift
//  TrialsOfTheEveryday
//
//  Created by Sebastian Maier on 09.05.24.
//

import SwiftUI

struct PixelAnimationView: View {
    @State private var currentIndex = 0
    @State private var timer: Timer?
    
    var imageNames: [String]
    var fps: Double
    
    var body: some View {
        Image(imageNames[currentIndex])
            .resizable()
            .onAppear {
                startTimer()
            }
            .onDisappear {
                stopTimer()
            }
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0 / fps, repeats: true) { _ in
            currentIndex = (currentIndex + 1) % imageNames.count
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
        currentIndex = 0
    }
}

