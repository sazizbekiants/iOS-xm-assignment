//
//  AppStore.swift
//  SurveyApp
//
//  Created by Sergey Azizbekyants on 28.07.25.
//

import Foundation
import ComposableArchitecture

// MARK: - App State
struct AppState: Equatable {
    var currentScreen: AppScreen = .initial
    var surveyState: SurveyState = SurveyState()
}

// MARK: - App Screen
enum AppScreen: Equatable {
    case initial
    case survey
}

// MARK: - App Actions
enum AppAction: Equatable {
    case survey(SurveyAction)
    case navigateToSurvey
    case navigateToInitial
}

// MARK: - App Environment
struct AppEnvironment {
    let surveyEnvironment: SurveyEnvironment
    
    init(surveyEnvironment: SurveyEnvironment = SurveyEnvironment()) {
        self.surveyEnvironment = surveyEnvironment
    }
}

// MARK: - App Reducer
@Reducer
struct AppReducer {
    var body: some Reducer<AppState, AppAction> {
        Scope(state: \AppState.surveyState, action: /AppAction.survey) {
            SurveyReducer()
        }
        Reduce { state, action in
            switch action {
            case .navigateToSurvey:
                state.currentScreen = .survey
                return .send(.survey(.startSurvey))
                
            case .navigateToInitial:
                state.currentScreen = .initial
                return .send(.survey(.resetSurvey))
            case .survey:
                return .none
            }
        }
    }
} 