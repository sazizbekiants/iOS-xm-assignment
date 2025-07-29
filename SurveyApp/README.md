# Survey App

A simple survey application built with SwiftUI and The Composable Architecture (TCA) that allows users to answer questions and submit their responses to a server.

## Features

### Initial Screen
- Clean, modern UI with app branding
- "Start Survey" button to begin the survey process
- Smooth navigation to the survey screen

### Survey Screen
- **Horizontal Pager Navigation**: Navigate between questions using Previous/Next buttons
- **Smart Button States**: Previous button disabled on first question, Next button disabled on last question
- **Dynamic Counter**: Shows "X of Y Questions Answered" at the top
- **Answer Management**: Text input for answers with real-time validation
- **Submit Functionality**: Submit individual answers with success/failure feedback
- **Memory Management**: Submitted answers are kept in memory during navigation
- **Banner Notifications**: Success and failure banners with retry functionality

### API Integration
- **Question Loading**: Fetches questions from `https://xm-assignment.web.fire`
- **Answer Submission**: POST requests to submit individual answers
- **Error Handling**: Comprehensive error handling with user-friendly messages
- **Retry Mechanism**: Automatic retry functionality for failed submissions

## Architecture

The app is built using **The Composable Architecture (TCA)** pattern, providing:

- **Predictable State Management**: Single source of truth for app state
- **Unidirectional Data Flow**: Actions → Reducer → State → View
- **Testability**: Easy to test business logic with TestStore
- **Modularity**: Clear separation of concerns

### Project Structure

```
SurveyApp/
├── Models/
│   └── SurveyModels.swift          # Data models and state
├── Networking/
│   └── SurveyAPI.swift             # API service and error handling
├── Store/
│   ├── SurveyStore.swift           # Survey-specific actions and reducer
│   └── AppStore.swift              # App-level state management
├── Views/
│   ├── InitialScreenView.swift     # Welcome screen
│   ├── SurveyScreenView.swift      # Survey interface
│   └── MainContentView.swift       # Navigation and banner management
└── SurveyAppApp.swift              # App entry point
```

## Requirements

- iOS 15.0+
- Xcode 14.0+
- Swift 5.9+

## Dependencies

- **The Composable Architecture**: For state management and architecture
- **Combine**: For reactive programming and async operations

## Installation

1. Clone the repository
2. Open `SurveyApp.xcodeproj` in Xcode
3. Add the TCA dependency:
   - In Xcode, go to File → Add Package Dependencies
   - Enter: `https://github.com/pointfreeco/swift-composable-architecture`
   - Select the latest version
4. Build and run the project

## Testing

The project includes comprehensive testing:

### Unit Tests (`SurveyAppTests/`)
- **SurveyStoreTests**: Tests all business logic and state management
- **Mock API Service**: Simulates API responses for testing
- **Test Coverage**: Actions, state changes, navigation, and error handling

### UI Tests (`SurveyAppUITests/`)
- **User Interface Testing**: Tests all UI interactions
- **Navigation Testing**: Verifies screen transitions
- **Form Validation**: Tests input validation and button states
- **API Integration**: Tests success and failure scenarios

### Running Tests
```bash
# Run unit tests
xcodebuild test -scheme SurveyApp -destination 'platform=iOS Simulator,name=iPhone 15'

# Run UI tests
xcodebuild test -scheme SurveyApp -destination 'platform=iOS Simulator,name=iPhone 15' -only-testing:SurveyAppUITests
```

## API Endpoints

### Base URL
```
https://xm-assignment.web.fire
```

### Questions Endpoint
- **Method**: GET
- **Response**: Array of survey questions
```json
[
  {"id": 1, "question": "What is your favourite colour?"},
  {"id": 2, "question": "What is your favourite food?"}
]
```

### Submit Answer Endpoint
- **Method**: POST
- **Request**: 
```json
{"id": 1, "answer": "Blue"}
```
- **Success Response**: 200 status
- **Failure Response**: 400 status

## Key Features Implementation

### 1. Horizontal Pager Navigation
- Previous/Next buttons with proper state management
- Disabled states based on current question position
- Smooth transitions between questions

### 2. Answer Memory Management
- Answers stored in memory during session
- Prevents re-submission of answered questions
- Maintains state during navigation

### 3. Dynamic Counter
- Real-time updates of answered questions count
- Displays "X of Y Questions Answered"
- Updates after each successful submission

### 4. Banner Notifications
- **Success Banner**: Green banner with "Success!" message
- **Failure Banner**: Orange banner with "Failure...." and retry button
- **Auto-dismiss**: Success banner disappears after 3 seconds
- **Manual retry**: Failure banner includes retry functionality

### 5. Form Validation
- Submit button disabled for empty answers
- Submit button disabled for already answered questions
- Real-time validation as user types

## State Management

The app uses TCA's state management pattern:

```swift
struct SurveyState: Equatable {
    var questions: [SurveyQuestion] = []
    var currentQuestionIndex: Int = 0
    var answers: [Int: String] = [:]
    var isLoading: Bool = false
    var errorMessage: String?
    var showSuccessBanner: Bool = false
    var showFailureBanner: Bool = false
}
```

## Error Handling

Comprehensive error handling for:
- Network connectivity issues
- Invalid API responses
- Server errors (400, 500, etc.)
- JSON parsing errors
- User-friendly error messages

## Performance Considerations

- **Memory Efficient**: Only stores necessary data in memory
- **Network Optimization**: Minimal API calls, proper error handling
- **UI Responsiveness**: Async operations don't block UI
- **State Management**: Efficient state updates with TCA

## Future Enhancements

- **Offline Support**: Local storage for offline functionality
- **Progress Persistence**: Save progress across app sessions
- **Analytics**: Track user interaction patterns
- **Accessibility**: Enhanced accessibility features
- **Dark Mode**: Full dark mode support
- **Animations**: Enhanced UI animations and transitions

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Submit a pull request

## License

This project is licensed under the MIT License. 