//
//  QuizViewModel.swift
//  Quiz
//
//  Created by Gustavo Severo on 09/02/20.
//  Copyright © 2020 Severo. All rights reserved.
//

import UIKit

// MARK: - View State -
struct QuizState {
    var quizIsRunning: Bool
    var titleText: String = "What are all the java keywords?         "
    var buttonText: String
    var correctWordsText: String
    var timeLeft: String
    var showAlert: Bool = false
    var reloadTableView: Bool = false
    var focusTextField: Bool = false
    var clearTextField: Bool = false
    var isLoading: Bool = false
}

// MARK: - View Model -
class QuizViewModel {
    
    // MARK: - Model -
    var model: QuizModel = QuizModel(question: "", answer: [])
    var alertModel: AlertModel?
    
    // MARK: - Timer -
    var timer: Timer?
    var timeLeft: Int = 300
    
    // MARK: - Timer -
    var correctWords: [String] = [] {
        didSet {
            updateCorrectWords()
        }
    }
    
    // MARK: A struct that holds the View State.
    var state: QuizState = QuizState(quizIsRunning: false, buttonText: "Start", correctWordsText: "00/00", timeLeft: "5:00") {
        didSet {
            callback(state)
        }
    }
    
    // MARK: A callback that connects the ViewModel with the ViewController
    var callback: ((QuizState) -> Void)
    
    // MARK: - Initializer -
    public init(callback: @escaping (QuizState) -> Void){
        self.callback = callback
        self.callback(state)
        self.getQuiz()
    }
}

// MARK: - Service -
extension QuizViewModel {
    func getQuiz(){
        self.showLoading()
        Service.request(router: Router.getQuiz) { (model: QuizModel?) in
            if let unwrappedModel = model {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
                    self.hideLoading()
                }
                self.model = unwrappedModel
                self.setupQuiz()
            }
        }
    }
}

// MARK: - Inputs -
extension QuizViewModel {
    // MARK: Called when the Action Button is Tapped
    func actionButtonPressed(){
        startQuiz()
    }

    // MARK: Called when the Alert Button is called.
    func alertButtonPressed() {
        state.showAlert = false
        startQuiz()
    }
    
    // MARK: Add a word hit to the Quiz.
    func didTypeWord(word: String){
        if model.answer.contains(word) && !correctWords.contains(word) && state.quizIsRunning{
            correctWords.insert(word, at: 0)
            state.clearTextField = true
        } else {
            state.clearTextField = false
        }
    }
}

// MARK: - Outputs -
extension QuizViewModel {
    
    // MARK: Updates the time left label on the Quiz Screen
    func showTimeLeft(){
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional

        if let formattedString = formatter.string(from: TimeInterval(timeLeft)) {
            state.timeLeft = formattedString
        }
    }
    
    // MARK: Show an alert either praising the player or telling his score.
    func showAlert(){
        if correctWords.count == model.answer.count {
            // If the player completes the quiz in less than 5 min, an alert will praise him.
            alertModel = AlertModel(title: "Congratulations",
                                    description: "Good job! You found all the answers on time. Keep up with the great work.",
                                    buttonText: "Play Again")
        } else {
            // If the player doesn't complete within 5 min, an alert will tell him his score.
            alertModel = AlertModel(title: "Time finished",
                                    description: "Sorry, time is up! You got \(correctWords.count) out of \(model.answer.count) answers.",
                                    buttonText: "Try Again")
        }
        state.showAlert = true
    }
    
    // MARK: Update the hits of the correct words.
    func updateCorrectWords(){
        state.reloadTableView = true
        let correctWordsString = correctWords.count < 10 ? "0\(correctWords.count)": correctWords.count.description
        state.correctWordsText = "\(correctWordsString)/\(model.answer.count)"
        
        if correctWords.count == model.answer.count {
            endQuiz()
        }
    }
    
    // MARK: Show an Activity Indicator Loader
    func showLoading(){
        state.isLoading = true
    }
    
    // MARK: Hide an Activity Indicator Loader
    func hideLoading(){
        state.isLoading = false
    }
}

// MARK: - Quiz Logic -
extension QuizViewModel {
    
    // MARK: Setup the Quiz.
    func setupQuiz(){
        self.updateCorrectWords()
        self.showTimeLeft()
        state.titleText = model.question
    }
    
    // MARK: Starts the Quiz.
    func startQuiz(){
        state.reloadTableView = true
        state.buttonText = "Reset"
        state.quizIsRunning = true
        correctWords = []
        startTimer()
    }
    
    // MARK: Ends the Quiz.
    func endQuiz(){
        state.reloadTableView = false
        timer?.invalidate()
        state.quizIsRunning = false
        showAlert()
    }
}

// MARK: - Timer -
extension QuizViewModel {
    // MARK: Start the Quiz Timer.
    func startTimer(){
        resetTimer()
        timer = Timer.scheduledTimer(timeInterval: 1,
                             target: self,
                             selector: #selector(updateTimeLeft),
                             userInfo: nil,
                             repeats: true)
    }
    
    // MARK: Update the Quiz Timer every second.
    @objc func updateTimeLeft(){
        if timeLeft > 0 {
            timeLeft -= 1
            state.reloadTableView = false
            showTimeLeft()
        } else {
            endQuiz()
        }
    }
    
    // MARK: Reset the Quiz Timer.
    func resetTimer(){
        timeLeft = AppConstants.quizTime
        timer?.invalidate()
        showTimeLeft()
    }
}
