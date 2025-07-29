//
//  InitialScreenView.swift
//  SurveyApp
//
//  Created by Sergey Azizbekyants on 28.07.25.
//

import SwiftUI
import ComposableArchitecture

struct InitialScreenView: View {
    let store: Store<AppState, AppAction>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack(spacing: 30) {
                Spacer()
                
                // App Title
                VStack(spacing: 16) {
                    Image(systemName: "doc.text.magnifyingglass")
                        .font(.system(size: 80))
                        .foregroundColor(.blue)
                    
                    Text("Survey App")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text("Complete surveys and share your thoughts")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                
                Spacer()
                
                // Start Survey Button
                Button(action: {
                    viewStore.send(.navigateToSurvey)
                }) {
                    HStack {
                        Image(systemName: "play.fill")
                            .font(.headline)
                        Text("Start Survey")
                            .font(.headline)
                        .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.blue)
                    )
                    .padding(.horizontal, 40)
                }
                .buttonStyle(PlainButtonStyle())
                
                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    InitialScreenView(
        store: Store(
            initialState: AppState(),
            reducer: AppReducer.init
        )
    )
} 