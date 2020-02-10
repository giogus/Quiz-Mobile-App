//
//  QuizModel.swift
//  Quiz
//
//  Created by Gustavo Severo on 09/02/20.
//  Copyright © 2020 Severo. All rights reserved.
//

public struct QuizModel: Codable {
    let question: String
    let answer: [String]
}
