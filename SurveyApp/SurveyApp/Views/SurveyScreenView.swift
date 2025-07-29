//
//  SurveyScreenView.swift
//  SurveyApp
//
//  Created by Sergey Azizbekyants on 28.07.25.
//

import SwiftUI
import ComposableArchitecture

struct SurveyScreenView: View {
    let store: Store<AppState, AppAction>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            NavigationView {
                VStack(spacing: 0) {
                    // Header with counter and back button
                    headerView(viewStore: viewStore)
                    
                    // Question content
                    if viewStore.surveyState.isLoading {
                        loadingView
                    } else if let currentQuestion = viewStore.surveyState.currentQuestion {
                        questionContentView(
                            viewStore: viewStore,
                            question: currentQuestion
                        )
                    } else {
                        errorView(viewStore: viewStore)
                    }
                    
                    Spacer()
                    
                    // Navigation and submit buttons
                    if !viewStore.surveyState.isLoading && viewStore.surveyState.currentQuestion != nil {
                        navigationButtonsView(viewStore: viewStore)
                    }
                }
                .navigationBarHidden(true)
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
    
    // MARK: - Header View
    private func headerView(viewStore: ViewStore<AppState, AppAction>) -> some View {
        HStack {
            Button(action: {
                viewStore.send(.navigateToInitial)
            }) {
                Image(systemName: "chevron.left")
                    .font(.title2)
                    .foregroundColor(.blue)
            }
            
            Spacer()
            
            VStack(spacing: 4) {
                Text("\(viewStore.surveyState.submittedQuestionsCount) of \(viewStore.surveyState.questions.count)")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text("Questions Answered")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Placeholder for symmetry
            Image(systemName: "chevron.left")
                .font(.title2)
                .foregroundColor(.clear)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(Color(.systemBackground))
        .shadow(color: .black.opacity(0.1), radius: 1, x: 0, y: 1)
    }
    
    // MARK: - Loading View
    private var loadingView: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.5)
            
            Text("Loading questions...")
                .font(.body)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - Question Content View
    private func questionContentView(
        viewStore: ViewStore<AppState, AppAction>,
        question: SurveyQuestion
    ) -> some View {
        VStack(spacing: 24) {
            // Question text
            VStack(spacing: 16) {
                Text("Question \(viewStore.surveyState.currentQuestionIndex + 1) of \(viewStore.surveyState.questions.count)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text(question.question)
                    .font(.title2)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }
            
            // Answer text field
            VStack(alignment: .leading, spacing: 8) {
                Text("Your Answer")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                TextField("Enter your answer...", text: Binding(
                    get: { viewStore.surveyState.currentAnswer },
                    set: { newValue in
                        viewStore.send(.survey(.updateAnswer(newValue)))
                    }
                ))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .disabled(viewStore.surveyState.submittedAnswers.contains(question.id))
            }
            .padding(.horizontal, 20)
            
            Spacer()
        }
        .padding(.top, 40)
    }
    
    // MARK: - Error View
    private func errorView(viewStore: ViewStore<AppState, AppAction>) -> some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 60))
                .foregroundColor(.orange)
            
            Text("Failed to load questions")
                .font(.title2)
                .fontWeight(.semibold)
            
            if let errorMessage = viewStore.surveyState.errorMessage {
                Text(errorMessage)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Button("Retry") {
                viewStore.send(.survey(.loadQuestions))
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - Navigation Buttons View
    private func navigationButtonsView(viewStore: ViewStore<AppState, AppAction>) -> some View {
        VStack(spacing: 16) {
            // Submit button
            Button(action: {
                viewStore.send(.survey(.submitAnswer))
            }) {
                HStack {
                    Image(systemName: "paperplane.fill")
                        .font(.headline)
                    Text("Submit")
                        .font(.headline)
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(viewStore.surveyState.canSubmitCurrentQuestion ? Color.blue : Color.gray)
                )
            }
            .disabled(!viewStore.surveyState.canSubmitCurrentQuestion)
            .buttonStyle(PlainButtonStyle())
            
            // Navigation buttons
            HStack(spacing: 16) {
                Button(action: {
                    viewStore.send(.survey(.goToPreviousQuestion))
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                            .font(.headline)
                        Text("Previous")
                            .font(.headline)
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(viewStore.surveyState.canGoToPrevious ? Color.blue : Color.gray)
                    )
                }
                .disabled(!viewStore.surveyState.canGoToPrevious)
                .buttonStyle(PlainButtonStyle())
                
                Button(action: {
                    viewStore.send(.survey(.goToNextQuestion))
                }) {
                    HStack {
                        Text("Next")
                            .font(.headline)
                            .fontWeight(.semibold)
                        Image(systemName: "chevron.right")
                            .font(.headline)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(viewStore.surveyState.canGoToNext ? Color.blue : Color.gray)
                    )
                }
                .disabled(!viewStore.surveyState.canGoToNext)
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
    }
}

// MARK: - Banner Views
struct SuccessBannerView: View {
    let onDismiss: () -> Void
    
    var body: some View {
        HStack {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
            
            Text("Success!")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(Color.green)
        .cornerRadius(12)
        .padding(.horizontal, 20)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                onDismiss()
            }
        }
    }
}

struct FailureBannerView: View {
    let onRetry: () -> Void
    let onDismiss: () -> Void
    
    var body: some View {
        HStack {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.orange)
            
            Text("Failure....")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
            
            Spacer()
            
            Button("Retry") {
                onRetry()
            }
            .font(.subheadline)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Color.white.opacity(0.2))
            .cornerRadius(8)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(Color.orange)
        .cornerRadius(12)
        .padding(.horizontal, 20)
    }
}

#Preview {
    SurveyScreenView(
        store: Store(
            initialState: AppState(),
            reducer: AppReducer.init
        )
    )
} 