//
//  SurveyAPI.swift
//  SurveyApp
//
//  Created by Sergey Azizbekyants on 28.07.25.
//

import Foundation
import Combine

// MARK: - API Errors
enum SurveyAPIError: Error, Equatable {
    case invalidURL
    case networkError(String)
    case invalidResponse
    case serverError(Int)
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .networkError(let message):
            return "Network error: \(message)"
        case .invalidResponse:
            return "Invalid response"
        case .serverError(let code):
            return "Server error: \(code)"
        }
    }
}

// MARK: - API Service Protocol
protocol SurveyAPIServiceProtocol {
    func fetchQuestions() -> AnyPublisher<[SurveyQuestion], SurveyAPIError>
    func submitAnswer(_ request: SurveySubmissionRequest) -> AnyPublisher<SurveySubmissionResponse, SurveyAPIError>
}

// MARK: - API Service Implementation
class SurveyAPIService: SurveyAPIServiceProtocol {
    private let baseURL = "https://xm-assignment.web.app"
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetchQuestions() -> AnyPublisher<[SurveyQuestion], SurveyAPIError> {
        guard let url = URL(string: "\(baseURL)/questions") else {
            return Fail(error: SurveyAPIError.invalidURL)
                .eraseToAnyPublisher()
        }

        return session.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [SurveyQuestion].self, decoder: JSONDecoder())
            .mapError { error in
                if error is DecodingError {
                    return SurveyAPIError.invalidResponse
                }
                return SurveyAPIError.networkError(error.localizedDescription)
            }
            .eraseToAnyPublisher()
    }

    func submitAnswer(_ request: SurveySubmissionRequest) -> AnyPublisher<SurveySubmissionResponse, SurveyAPIError> {
        guard let url = URL(string: "\(baseURL)/question/submit") else {
            return Fail(error: SurveyAPIError.invalidURL)
                .eraseToAnyPublisher()
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            urlRequest.httpBody = try JSONEncoder().encode(request)
        } catch {
            return Fail(error: SurveyAPIError.invalidResponse)
                .eraseToAnyPublisher()
        }

        return session.dataTaskPublisher(for: urlRequest)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw SurveyAPIError.invalidResponse
                }

                switch httpResponse.statusCode {
                case 200:
                    return SurveySubmissionResponse(success: true, message: "Success!")
                case 400:
                    return SurveySubmissionResponse(success: false, message: "Failure....")
                default:
                    throw SurveyAPIError.serverError(httpResponse.statusCode)
                }
            }
            .mapError { error in
                if let apiError = error as? SurveyAPIError {
                    return apiError
                }
                return SurveyAPIError.networkError(error.localizedDescription)
            }
            .eraseToAnyPublisher()
    }
}

// MARK: - Async Extension for Combine Publishers
extension Publisher {
    func async() async throws -> Output {
        try await withCheckedThrowingContinuation { continuation in
            var cancellable: AnyCancellable?
            cancellable = first()
                .sink(
                    receiveCompletion: { completion in
                        switch completion {
                        case .finished:
                            break
                        case .failure(let error):
                            continuation.resume(throwing: error)
                        }
                        cancellable?.cancel()
                    },
                    receiveValue: { value in
                        continuation.resume(returning: value)
                        cancellable?.cancel()
                    }
                )
        }
    }
} 
