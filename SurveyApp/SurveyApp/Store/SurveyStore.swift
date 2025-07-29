//
//  SurveyStore.swift
//  SurveyApp
//
//  Created by Sergey Azizbekyants on 28.07.25.
//

import Foundation
import Combine
import ComposableArchitecture



// MARK: - Survey Actions
enum SurveyAction: Equatable {
    case startSurvey
    case loadQuestions
    case questionsLoadedSuccess([SurveyQuestion])
    case questionsLoadedFailure(SurveyAPIError)
    case updateAnswer(String)
    case goToPreviousQuestion
    case goToNextQuestion
    case submitAnswer
    case answerSubmittedSuccess(SurveySubmissionResponse)
    case answerSubmittedFailure(SurveyAPIError)
    case showSuccessBanner
    case hideSuccessBanner
    case showFailureBanner
    case hideFailureBanner
    case retrySubmission
    case resetSurvey
}

// MARK: - Survey Environment
struct SurveyEnvironment {
    let apiService: SurveyAPIServiceProtocol
    let mainQueue: AnySchedulerOf<DispatchQueue>
    
    init(
        apiService: SurveyAPIServiceProtocol = SurveyAPIService(),
        mainQueue: AnySchedulerOf<DispatchQueue> = .main
    ) {
        self.apiService = apiService
        self.mainQueue = mainQueue
    }
}

// MARK: - Survey Reducer
@Reducer
struct SurveyReducer {
    var body: some Reducer<SurveyState, SurveyAction> {
        Reduce { state, action in
            let environment = SurveyEnvironment()
            
            switch action {
                    case .startSurvey:
            state.currentQuestionIndex = 0
            state.answers = [:]
            state.submittedAnswers = []
            state.errorMessage = nil
            state.showSuccessBanner = false
            state.showFailureBanner = false
            return .send(.loadQuestions)
                
            case .loadQuestions:
                state.isLoading = true
                state.errorMessage = nil
                return .run { send in
                    do {
                        let questions = try await environment.apiService.fetchQuestions().async()
                        await send(.questionsLoadedSuccess(questions))
                    } catch {
                        await send(.questionsLoadedFailure(error as? SurveyAPIError ?? .networkError(error.localizedDescription)))
                    }
                }
                
            case .questionsLoadedSuccess(let questions):
                state.questions = questions
                state.isLoading = false
                return .none
                
            case .questionsLoadedFailure(let error):
                state.errorMessage = error.localizedDescription
                state.isLoading = false
                return .none
                
            case .updateAnswer(let answer):
                if let currentQuestion = state.currentQuestion {
                    state.answers[currentQuestion.id] = answer
                }
                return .none
                
            case .goToPreviousQuestion:
                if state.canGoToPrevious {
                    state.currentQuestionIndex -= 1
                }
                return .none
                
            case .goToNextQuestion:
                if state.canGoToNext {
                    state.currentQuestionIndex += 1
                }
                return .none
                
            case .submitAnswer:
                guard state.canSubmitCurrentQuestion,
                      let currentQuestion = state.currentQuestion else {
                    return .none
                }
                
                let request = SurveySubmissionRequest(
                    id: currentQuestion.id,
                    answer: state.currentAnswer
                )
                
                return .run { send in
                    do {
                        let response = try await environment.apiService.submitAnswer(request).async()
                        if response.success {
                            await send(.answerSubmittedSuccess(response))
                        } else {
                            await send(.answerSubmittedFailure(.serverError(400)))
                        }
                    } catch {
                        await send(.answerSubmittedFailure(error as? SurveyAPIError ?? .networkError(error.localizedDescription)))
                    }
                }
                
            case .answerSubmittedSuccess(_):
                if let currentQuestion = state.currentQuestion {
                    state.submittedAnswers.insert(currentQuestion.id)
                }
                state.showSuccessBanner = true
                return .run { send in
                    try await environment.mainQueue.sleep(for: .seconds(3))
                    await send(.hideSuccessBanner)
                }
                .cancellable(id: "bannerTimer")
                
            case .answerSubmittedFailure(_):
                state.showFailureBanner = true
                return .run { send in
                    try await environment.mainQueue.sleep(for: .seconds(3))
                    await send(.hideFailureBanner)
                }
                .cancellable(id: "bannerTimer")
                
            case .showSuccessBanner:
                state.showSuccessBanner = true
                return .none
                
            case .hideSuccessBanner:
                state.showSuccessBanner = false
                return .cancel(id: "bannerTimer")
                
            case .showFailureBanner:
                state.showFailureBanner = true
                return .none
                
            case .hideFailureBanner:
                state.showFailureBanner = false
                return .cancel(id: "bannerTimer")
                
            case .retrySubmission:
                state.showFailureBanner = false
                return .send(.submitAnswer)
                
            case .resetSurvey:
                state = SurveyState()
                return .none
            }
        }
    }
}

let surveyReducer = SurveyReducer() 