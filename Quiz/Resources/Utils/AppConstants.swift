//
//  AppConstants.swift
//  Quiz
//
//  Created by Gustavo Severo on 09/02/20.
//  Copyright © 2020 Severo. All rights reserved.
//

import Foundation

class AppConstants {
    static var quizTime: Int {
        let isFailTestCase = ProcessInfo.processInfo.arguments.contains("TestCase_Fail")
        return isFailTestCase ? 10:300
    }
    static var quizEndpoint = "https://codechallenge.arctouch.com/quiz/1"
}
