//
//  MainContentView.swift
//  SurveyApp
//
//  Created by Sergey Azizbekyants on 28.07.25.
//

import SwiftUI
import ComposableArchitecture

struct MainContentView: View {
    let store: Store<AppState, AppAction>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ZStack {
                // Main content
                Group {
                    switch viewStore.currentScreen {
                    case .initial:
                        InitialScreenView(store: store)
                    case .survey:
                        SurveyScreenView(store: store)
                    }
                }
                
                // Banner overlays
                VStack {
                    Spacer()
                    
                    if viewStore.surveyState.showSuccessBanner {
                        SuccessBannerView {
                            viewStore.send(.survey(.hideSuccessBanner))
                        }
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                    
                    if viewStore.surveyState.showFailureBanner {
                        FailureBannerView(
                            onRetry: {
                                viewStore.send(.survey(.retrySubmission))
                            },
                            onDismiss: {
                                viewStore.send(.survey(.hideFailureBanner))
                            }
                        )
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
                .animation(.easeInOut(duration: 0.3), value: viewStore.surveyState.showSuccessBanner)
                .animation(.easeInOut(duration: 0.3), value: viewStore.surveyState.showFailureBanner)
            }
        }
    }
}

#Preview {
    MainContentView(
        store: Store(
            initialState: AppState(),
            reducer: AppReducer.init
        )
    )
} 