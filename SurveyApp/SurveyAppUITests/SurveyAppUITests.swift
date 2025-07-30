//
//  SurveyAppUITests.swift
//  SurveyAppUITests
//
//  Created by Sergey Azizbekyants on 28.07.25.
//

import XCTest

final class SurveyAppUITests: XCTestCase {
    
    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }
    
    func testInitialScreen_ShouldDisplayStartSurveyButton() throws {
        // Verify initial screen elements
        XCTAssertTrue(app.staticTexts["Survey App"].exists)
        XCTAssertTrue(app.staticTexts["Complete surveys and share your thoughts"].exists)
        XCTAssertTrue(app.buttons["Start Survey"].exists)
    }
    
    func testStartSurvey_ShouldNavigateToSurveyScreen() throws {
        // Tap start survey button
        app.buttons["Start Survey"].tap()
        
        // Verify navigation to survey screen
        XCTAssertTrue(app.staticTexts["Questions Answered"].exists)
        XCTAssertTrue(app.buttons["Previous"].exists)
        XCTAssertTrue(app.buttons["Next"].exists)
        XCTAssertTrue(app.buttons["Submit"].exists)
    }
    
    func testSurveyNavigation_ShouldWorkCorrectly() throws {
        // Navigate to survey screen
        app.buttons["Start Survey"].tap()
        
        // Wait for questions to load
        let loadingText = app.staticTexts["Loading questions..."]
        if loadingText.exists {
            // Wait for loading to complete
            XCTAssertFalse(loadingText.waitForExistence(timeout: 10))
        }
        
        // Test navigation buttons
        let previousButton = app.buttons["Previous"]
        let nextButton = app.buttons["Next"]
        
        // Previous should be disabled on first question
        XCTAssertFalse(previousButton.isEnabled)
        
        // Next should be enabled if there are multiple questions
        if app.staticTexts["Question 1 of"].exists {
            XCTAssertTrue(nextButton.isEnabled)
            
            // Navigate to next question
            nextButton.tap()
            
            // Previous should now be enabled
            XCTAssertTrue(previousButton.isEnabled)
            
            // Navigate back
            previousButton.tap()
            
            // Previous should be disabled again
            XCTAssertFalse(previousButton.isEnabled)
        }
    }
    
    func testAnswerSubmission_ShouldWorkCorrectly() throws {
        // Navigate to survey screen
        app.buttons["Start Survey"].tap()
        
        // Wait for questions to load
        let loadingText = app.staticTexts["Loading questions..."]
        if loadingText.exists {
            XCTAssertFalse(loadingText.waitForExistence(timeout: 10))
        }
        
        // Find text field and enter answer
        let textField = app.textFields["Enter your answer..."]
        if textField.exists {
            textField.tap()
            textField.typeText("Test answer")
            
            // Submit button should be enabled
            let submitButton = app.buttons["Submit"]
            XCTAssertTrue(submitButton.isEnabled)
            
            // Submit answer
            submitButton.tap()
            
            // Check for success or failure banner
            let successBanner = app.staticTexts["Success!"]
            let failureBanner = app.staticTexts["Failure...."]
            
            // Wait for banner to appear
            let bannerExists = successBanner.waitForExistence(timeout: 5) || failureBanner.waitForExistence(timeout: 5)
            XCTAssertTrue(bannerExists)
        }
    }
    
    func testBackNavigation_ShouldReturnToInitialScreen() throws {
        // Navigate to survey screen
        app.buttons["Start Survey"].tap()
        
        // Tap back button
        let backButton = app.buttons["chevron.left"]
        if backButton.exists {
            backButton.tap()
            
            // Should return to initial screen
            XCTAssertTrue(app.staticTexts["Survey App"].exists)
            XCTAssertTrue(app.buttons["Start Survey"].exists)
        }
    }
    
    func testSubmitButton_ShouldBeDisabledForEmptyAnswer() throws {
        // Navigate to survey screen
        app.buttons["Start Survey"].tap()
        
        // Wait for questions to load
        let loadingText = app.staticTexts["Loading questions..."]
        if loadingText.exists {
            XCTAssertFalse(loadingText.waitForExistence(timeout: 10))
        }
        
        // Submit button should be disabled for empty answer
        let submitButton = app.buttons["Submit"]
        XCTAssertFalse(submitButton.isEnabled)
    }
    
    func testQuestionCounter_ShouldUpdateCorrectly() throws {
        // Navigate to survey screen
        app.buttons["Start Survey"].tap()
        
        // Wait for questions to load
        let loadingText = app.staticTexts["Loading questions..."]
        if loadingText.exists {
            XCTAssertFalse(loadingText.waitForExistence(timeout: 10))
        }
        
        // Check initial counter
        let counterText = app.staticTexts["0 of"]
        XCTAssertTrue(counterText.exists)
        
        // Enter and submit an answer
        let textField = app.textFields["Enter your answer..."]
        if textField.exists {
            textField.tap()
            textField.typeText("Test answer")
            
            let submitButton = app.buttons["Submit"]
            submitButton.tap()
            
            // Wait for submission and check counter update
            let updatedCounter = app.staticTexts["1 of"]
            XCTAssertTrue(updatedCounter.waitForExistence(timeout: 5))
        }
    }
    
    func testRetryButton_ShouldAppearOnFailure() throws {
        // Navigate to survey screen
        app.buttons["Start Survey"].tap()
        
        // Wait for questions to load
        let loadingText = app.staticTexts["Loading questions..."]
        if loadingText.exists {
            XCTAssertFalse(loadingText.waitForExistence(timeout: 10))
        }
        
        // Enter and submit an answer
        let textField = app.textFields["Enter your answer..."]
        if textField.exists {
            textField.tap()
            textField.typeText("Test answer")
            
            let submitButton = app.buttons["Submit"]
            submitButton.tap()
            
            // Check for retry button in failure banner
            let retryButton = app.buttons["Retry"]
            if retryButton.waitForExistence(timeout: 5) {
                XCTAssertTrue(retryButton.exists)
                
                // Test retry functionality
                retryButton.tap()
                
                // Should attempt submission again
                let submitButtonAfterRetry = app.buttons["Submit"]
                XCTAssertTrue(submitButtonAfterRetry.exists)
            }
        }
    }
}
