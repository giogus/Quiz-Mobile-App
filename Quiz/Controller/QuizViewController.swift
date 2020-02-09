//
//  QuizViewController.swift
//  Quiz
//
//  Created by Gustavo Severo on 09/02/20.
//  Copyright © 2020 Severo. All rights reserved.
//

import UIKit

class QuizViewController: UIViewController {
    
    // MARK: - IBOutlets -
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var wordTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var correctWordsLabel: UILabel!
    @IBOutlet weak var timeLeftLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    
    // MARK: - IBActions -
    @IBAction func actionDidTap(_ sender: Any) {}
    
}

// MARK: - Lifecycle -
extension QuizViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

// MARK: - UI -
extension QuizViewController {
    // This method should be called when viewDidLoad is called. It's used to tweak some components styling that aren't possible to do on Interface Builder.
    func setupUI(){
        setupTextFieldUI()
    }
    
    // This method should be called when setupUI is called. It's used to change wordTextField placeholder text with some color.
    func setupTextFieldUI(){
        let placeholderColor = UIColor(red: 162/255, green: 162/255, blue: 162/255, alpha: 1.0)
        wordTextField.attributedPlaceholder = NSAttributedString(string: "Insert Word", attributes: [.foregroundColor: placeholderColor])
    }
}
