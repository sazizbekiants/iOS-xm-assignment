//
//  SurveyModels.swift
//  SurveyApp
//
//  Created by Sergey Azizbekyants on 28.07.25.
//

import Foundation

// MARK: - Survey Question Model
struct SurveyQuestion: Codable, Identifiable, Equatable {
    let id: Int
    let question: String
}

// MARK: - Survey Answer Model
struct SurveyAnswer: Codable, Identifiable, Equatable {
    let id: Int
    let answer: String
}

// MARK: - Survey Submission Request
struct SurveySubmissionRequest: Codable {
    let id: Int
    let answer: String
}

// MARK: - Survey Submission Response
struct SurveySubmissionResponse: Codable, Equatable {
    let success: Bool
    let message: String
}

// MARK: - Survey State
struct SurveyState: Equatable {
    var questions: [SurveyQuestion] = []
    var currentQuestionIndex: Int = 0
    var answers: [Int: String] = [:] // Typed answers
    var submittedAnswers: Set<Int> = [] // IDs of successfully submitted questions
    var isLoading: Bool = false
    var errorMessage: String?
    var showSuccessBanner: Bool = false
    var showFailureBanner: Bool = false
    var submittedQuestionsCount: Int {
        submittedAnswers.count
    }
    
    var currentQuestion: SurveyQuestion? {
        guard currentQuestionIndex < questions.count else { return nil }
        return questions[currentQuestionIndex]
    }
    
    var currentAnswer: String {
        guard let currentQuestion = currentQuestion else { return "" }
        return answers[currentQuestion.id] ?? ""
    }
    
    var canSubmitCurrentQuestion: Bool {
        guard let currentQuestion = currentQuestion else { return false }
        return !currentAnswer.isEmpty && !submittedAnswers.contains(currentQuestion.id)
    }
    
    var canGoToPrevious: Bool {
        currentQuestionIndex > 0
    }
    
    var canGoToNext: Bool {
        currentQuestionIndex < questions.count - 1
    }
} 