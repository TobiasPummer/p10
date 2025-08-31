//
//  TrialsOfTheEverydayApp.swift
//  TrialsOfTheEveryday
//
//  Created by Sebastian Maier on 08.05.24.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct TrialsOfTheEverydayApp: App {
    
    @StateObject var manager = HealthManager()
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @AppStorage("firstLaunch") private var firstLaunch: Bool = true
    @State var loading: Bool = true
    @StateObject var viewModel = DataContainerViewModel()
    
    var body: some Scene {
        WindowGroup {
            if firstLaunch {
                ClassPickerView()
                    
            } else {
                if loading {
                    LoadingView(loading: $loading, viewModel: viewModel)
                } else {
                  RootView(viewModel: viewModel, manager: manager)
                        
                }
            }
        }.environmentObject(manager)
    }
}
