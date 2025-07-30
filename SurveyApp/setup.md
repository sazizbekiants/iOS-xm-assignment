# Survey App Setup Guide

## Prerequisites
- Xcode 14.0 or later
- iOS 15.0+ deployment target
- Swift 5.9+

## Setup Instructions

### 1. Add TCA Dependency

1. Open `SurveyApp.xcodeproj` in Xcode
2. Go to **File** → **Add Package Dependencies...**
3. In the search field, enter: `https://github.com/pointfreeco/swift-composable-architecture`
4. Click **Add Package**
5. Select the latest version (1.0.0 or higher)
6. Click **Add Package**

### 2. Build and Run

1. Select your target device or simulator
2. Press **Cmd + R** to build and run the project
3. The app should launch and show the initial screen

## Project Structure

The project has been organized with a clean architecture:

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

## Features Implemented

✅ **Initial Screen**: Clean welcome screen with "Start Survey" button
✅ **Survey Navigation**: Horizontal pager with Previous/Next buttons
✅ **Smart Button States**: Previous disabled on first, Next disabled on last
✅ **Answer Management**: Text input with real-time validation
✅ **Submit Functionality**: Individual answer submission
✅ **Memory Management**: Answers kept in memory during navigation
✅ **Dynamic Counter**: "X of Y Questions Answered" display
✅ **Banner Notifications**: Success/Failure banners with retry
✅ **Error Handling**: Comprehensive error management
✅ **Unit Tests**: Complete test coverage for business logic
✅ **UI Tests**: End-to-end UI testing

## API Integration

The app connects to: `https://xm-assignment.web.fire`

- **GET** `/` - Fetches survey questions
- **POST** `/` - Submits individual answers

## Testing

### Run Unit Tests
```bash
xcodebuild test -scheme SurveyApp -destination 'platform=iOS Simulator,name=iPhone 15'
```

### Run UI Tests
```bash
xcodebuild test -scheme SurveyApp -destination 'platform=iOS Simulator,name=iPhone 15' -only-testing:SurveyAppUITests
```

## Troubleshooting

### Common Issues

1. **TCA Import Error**: Make sure TCA package is properly added to the project
2. **Build Errors**: Clean build folder (Cmd + Shift + K) and rebuild
3. **Simulator Issues**: Reset simulator content and settings

### Verification Steps

1. ✅ App launches to initial screen
2. ✅ "Start Survey" button navigates to survey screen
3. ✅ Questions load from API
4. ✅ Navigation buttons work correctly
5. ✅ Submit functionality works
6. ✅ Banners appear for success/failure
7. ✅ Counter updates correctly

## Architecture Benefits

- **Predictable State**: Single source of truth
- **Testable**: Easy to test with TestStore
- **Maintainable**: Clear separation of concerns
- **Scalable**: Easy to add new features
- **Type Safe**: Compile-time safety with Swift

## Next Steps

1. Test the app thoroughly
2. Run the test suite
3. Verify all requirements are met
4. Deploy or submit as required 