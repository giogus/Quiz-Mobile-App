//
//  QuizUITests.swift
//  QuizUITests
//
//  Created by Gustavo Severo on 09/02/20.
//  Copyright © 2020 Severo. All rights reserved.
//

import XCTest
@testable import Quiz

// GS TODO: Implement UI tests.
class QuizUITests: XCTestCase {
    
    // MARK: - Variables -
    let app = XCUIApplication()
    
    // MARK: - Tests -

    // - [✅] Insert words and have them counted as a hit as soon as the player types the last letter of each word.
    
    func testInsertWordAndCountHit(){
        app.launch()
        app.buttons["Start"].tap()
        
        let wordTextField = app.textFields["Insert Word"]
        wordTextField.tap()
        wordTextField.typeText(MockQuizModel.words[0])
        
        let hitLabelExists = app.staticTexts["01/50"].exists
        XCTAssert(hitLabelExists)
        
        app.terminate()
    }
    
    // - [🚫] After a hit, the input box will be cleared and focus will remain on the input box.
    
    func testAfterHitTextFieldWillBeClearedAndRemainWithFocus(){
        app.launch()
        app.buttons["Start"].tap()
        
        let wordTextField = app.textFields["Insert Word"]
        wordTextField.tap()
        wordTextField.typeText(MockQuizModel.words[0])
        
        sleep(2)
        
        XCTAssert(((wordTextField.value as? String)?.isEmpty ?? false))
    }
    
    // - [✅] There will be a 5 min timer to finish the game.
    // - [✅] If the player completes the quiz in less than 5 min, an alert will praise him.

    func testGameSuccess(){
        
        app.launch()
        app.buttons["Start"].tap()
        
        let wordTextField = app.textFields["Insert Word"]
        wordTextField.tap()
        
        MockQuizModel.words.forEach { (word) in
            wordTextField.typeText(word)
            sleep(1)
        }
        
        let alertTitleLabelExists = app.alerts.element(boundBy: 0).staticTexts["Congratulations"].exists
        
        XCTAssert(alertTitleLabelExists)
        
        app.terminate()
    }
    
    // - [✅] There will be a button to start the timer.
    // - [✅] If the player doesn't complete within 5 min, an alert will tell him his score.
    func testGameFail(){
        
        app.launchArguments = ["TestCase_Fail"]
        app.launch()
        
        app.buttons["Start"].tap()
        sleep(12)
        
        let alertTitleLabelExists = app.alerts.element(boundBy: 0).staticTexts["Time finished"].exists
        XCTAssert(alertTitleLabelExists)
        
        app.terminate()
    }
}
