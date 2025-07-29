//
//  SurveyAppApp.swift
//  SurveyApp
//
//  Created by Sergey Azizbekyants on 28.07.25.
//

import SwiftUI
import ComposableArchitecture

@main
struct SurveyAppApp: App {
    var body: some Scene {
        WindowGroup {
            MainContentView(
                store: Store(
                    initialState: AppState(),
                    reducer: AppReducer.init
                )
            )
        }
    }
}
